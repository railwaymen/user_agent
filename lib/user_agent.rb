class UserAgent
  VERSION = '0.0.1'
  
  attr_accessor :browser_name, :browser_version, :os_name, :os_version
  
  def initialize(user_agent)
    @user_agent = user_agent
    return if @user_agent.nil?
    extract_products_from_agent_string
    return if @products.empty?

    identify_browser
    identify_os
    identify_mobiles
  end
  
  def browser
    [browser_name, browser_version].compact.join(' ')
  end
  
  def os
    [os_name, os_version].compact.join(' ')
  end
  
  def string
    @user_agent || ""
  end
  
  def normalized_browser_version
    return browser_version if !browser_version || browser_version == "" || !(browser_version =~ /\d/)
    chars = browser_version =~ /([^\d\.]+$)/ ? $1 : ""
    nrs = browser_version.split(/\./)[0..1].each do |nr| 
      nr.gsub!(/^[0]+$/, "0")
    end
    
    if !nrs[1] || nrs[1] == ""
      nrs = [(nrs[0] || "").gsub(/(\d+).*$/, '\1.0')]
    end
    
    "#{nrs.join(".")}#{chars}"
  end
  
private

  MATCHER = Regexp.new(
    "([^/\s]*)" +                           # product token
    "(/([^\s]*))?" +                        # optional version
    "([\s]*\\[[a-zA-Z][a-zA-Z]\\])?" +      # optional old netscape
    "[\s]*" +                               # eat space!
    "(\\((([^()]|(\\([^()]*\\)))*)\\))?" +  # optional comment, allow one deep nested ()
    "[\s]*"                                 # eat space!
  )

  def extract_products_from_agent_string
    @products = @user_agent.scan(MATCHER).map{|match|
      [match[0], match[2], match[5]] unless match[0].empty?
    }.compact
  end
  
  # Browser Identification
  
  def identify_browser
    identify_browser_opera or
    identify_browser_chromeframe or
    identify_browser_chrome or
    identify_browser_honest or
    identify_browser_safari or
    identify_browser_compatible or
    identify_browser_mozilla
  end
  
  def identify_browser_opera
    return unless @user_agent =~ /Opera/
    
    if version = @products.detect{|product| product[0] == 'Version'}
      @browser_version = version[1]
    elsif opera = @products.detect{|product| product[0] == 'Opera'}
      if opera[1].nil?
        if @products[-2][0] == 'Opera'
          @browser_version = @products[-1][0]
        end
      else
        @browser_version = opera[1]
      end
    end
    @browser_name = case @user_agent
      when /Opera Mini\//i
        "Opera Mini"
      when /Opera Mobi\//i
        "Opera Mobile"
      else
        "Opera"
      end
  end
  
  def identify_browser_chrome
    return unless @user_agent =~ /Chrome/
    
    if chrome = @products.detect{|product| product[0] == 'Chrome'}
      @browser_version = chrome[1]
      @browser_name = "Chrome"
    end
  end
  
  def identify_browser_chromeframe
    return unless @user_agent =~ /chromeframe/
    
    @browser_version = nil
    @browser_name = "ChromeFrame"
  end
  
  def identify_browser_safari
    return unless @user_agent =~ /Safari|iPhone/
    
    if version = @products.detect{|product| product[0] == 'Version'}
      @browser_version = version[1]
    elsif browser = @products.detect{|product| product[0] == 'Safari'}
      @browser_version = safari_build_to_version(browser[1])
    end
    
    @browser_name = case @user_agent 
    when /webOS\//
     'Palm webkit'
    when /Mobile/
      'Safari Mobile'
    else
      'Safari'
    end
  end
  
  SAFARI_BUILD_TO_VERSION = {
    '85.5'=>'1.0',
    '85.7'=>'1.0.2',
    '85.8'=>'1.0.3',
    '85.8.1'=>'1.0.3',
    '100'=>'1.1',
    '100.1'=>'1.1.1',
    '125.7'=>'1.2.2',
    '125.8'=>'1.2.2',
    '125.9'=>'1.2.3',
    '125.11'=>'1.2.4',
    '125.12'=>'1.2.4',
    '312'=>'1.3',
    '312.3'=>'1.3.1',
    '312.3.1'=>'1.3.1',
    '312.5'=>'1.3.2',
    '312.6'=>'1.3.2',
    '412'=>'2.0',
    '412.2'=>'2.0',
    '412.2.2'=>'2.0',
    '412.5'=>'2.0.1',
    '416.12'=>'2.0.2',
    '416.13'=>'2.0.2',
    '417.8'=>'2.0.3',
    '417.9.2'=>'2.0.3',
    '417.9.3'=>'2.0.3',
    '419.3'=>'2.0.4',
    '419' => '2.0.4',
    '425.13' => '2.2'
  }
  
  def safari_build_to_version(build)
    SAFARI_BUILD_TO_VERSION[build] || build
  end
  
  def identify_browser_honest
    honest_browsers = %w(Firefox Netscape Camino Mosaic Galeon Prism prism Fluid)
    if browser = @products.detect{|product| honest_browsers.include? product[0]}
      @browser_version = browser[1]
      @browser_name = (browser[0] || "").capitalize
    end
  end
  
  def identify_browser_compatible
    compatible = /^compatible; ([^\s]+) ([^\s;]+)/
    if browser = @products.detect{|product| product[0] == 'Mozilla' && product[2] =~ compatible}
      # TODO? check_for_cloaked_products(AVANT_BROWSER, CRAZY_BROWSER);
      @browser_version = $2
      @browser_name = $1
    end
  end
  
  def identify_browser_mozilla
    first = @products.first
    if first[0] == 'Mozilla'
      if first[1].to_f < 5.0
        @browser_version = first[1]
        @browser_name = 'Netscape'
      else
        first[2] =~ /rv:([^s]+)/
        @browser_version = $1
        @browser_name = first[0]
      end
    end
  end
  
  # OS Identification
  
  def identify_os
    @comment_elements = @products[0][2].split(/\s*;\s*/) rescue []
    identify_os_windows or
    identify_os_apple or
    identify_os_linux or
    identify_os_other
  end
  
  def identify_os_windows
    return unless element = @comment_elements.detect{|e| e =~ /^win.*(\d|ce)/i} or
                  @user_agent =~ /Microsoft Windows/
    @os_version = case element
    when /Win.*95/       then '95'
    when /Win.*98/       then '98'
    when /Win.*9x 4.90/  then 'ME'
    when /Win.*NT 4.0/   then 'NT'
    when /Win.*NT 5.0/   then '2000'
    when /Win.*NT 5.1/   then 'XP'
    when /Win.*NT 6.0/   then 'Vista'
    when /Win.*NT 6.1/   then '7'
    when /Win.*CE/
      @browser_name = "MSIE Mobile" if @browser_name == "MSIE"
      'CE'
    end
    @os_name = 'Windows'
  end
  
  def identify_os_apple
    return unless element = @comment_elements.detect{|e| e =~ /Mac OS X/} or
                  element = @comment_elements.detect{|e| e =~ /Macintosh/}
                  
    @os_name = case @comment_elements[0]
    when /ipad/i
      'iPad'
    when /iphone/i, /ipod/i
      'iPhone'
    else
      case element
      when /Mac OS X/
        'Mac OS X'
      else
        'Macintosh'
      end
    end
    
    @os_version = case element
    when /OS ([0-9_\.]{3,}) like Mac OS X/
      $1.gsub('_','.')
    when /Mac OS X ([0-9_\.]{4,})/
      $1.gsub('_','.')
    when /iPhone OS ([0-9_\.]{3,})/
      $1.gsub('_','.')
    end
  end
  
  def identify_os_linux
    return unless element = @comment_elements.detect{|e| e =~ /linux/i}
    @os_name = 'Linux'
    @os_version = case @user_agent
    when /Ubuntu\/([0-9_\.]{3,})/
      "Ubuntu #{$1}"
    else
      nil
    end
  end
  
  def identify_mobiles
    case @user_agent
    when /^BlackBerry[^\/]*\/([\d\.]+)/
      @os_name = "BlackBerry OS"
      @os_version = $1
      @browser_name ||= "BlackBerry Browser"
    when /webOS\/([\d\.]+)/
      @os_name = "Palm webOS"
      @os_version = $1
    when /PalmCentro/, /PalmOS/, /PalmSource/
      @os_version, @browser_name, @browser_version = nil, nil, nil
      @os_name = "PalmOS"
    when /Symbian/
      @os_version = @user_agent =~ /SymbianOS\/([\d\.]+)/ ? $1 : nil
      if @browser_name =~ /Safari/
        @browser_name = "Webkit Mobile"
      end
      @os_name = "SymbianOS"
    when /Fennec\/([\.\da-z]+)/
      @os_version, @os_name = nil, nil if %w(Windows Linux).include?(@os_name)
      @browser_name = "Firefox Fennec"
      @browser_version = $1
    end
  end
  
  def identify_os_other
    %w(FreeBSD NetBSD OpenBSD SunOS Amiga BeOS IRIX OS/2 Warp).each do |os|
      os_regexp = Regexp.new(Regexp.escape(os))
      if @comment_elements.detect{|e| e =~ os_regexp}
        @os_name = os
        return
      end
    end
  end
end
