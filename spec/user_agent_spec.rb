require File.dirname(__FILE__) + '/spec_helper.rb'

describe UserAgent do

  describe '#browser' do
    it "should identify browser name and version (if available)" do
      examples = {
        "Firefox 0.9.3"     => "Mozilla/5.0 (Windows; U; Win98; de-DE; rv:1.7) Gecko/20040803 Firefox/0.9.3",
        "Firefox 1.5.0.3"   => "Mozilla/5.0 (Windows; U; Win 9x 4.90; en-US; rv:1.8.0.3) Gecko/20060426 Firefox/1.5.0.3",
        "Firefox 2.0.0.18"  => "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.8.1.18) Gecko/20081029 Firefox/2.0.0.18",
        "Firefox 3.0b5"     => "Mozilla/5.0 (Windows; U; Windows NT 6.0; de; rv:1.9b5) Gecko/2008032620 Firefox/3.0b5",
        "Firefox 3.1.6"     => "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.2) Gecko/2008092313 Ubuntu/8.04 (hardy) Firefox/3.1.6",
        "Firefox 3.5"       => "Mozilla/5.0 (Windows; U; Windows NT 5.1; es-ES; rv:1.9.1) Gecko/20090624 Firefox/3.5",
        "MSIE 5.5"          => "Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)",
        "MSIE 7.0"          => "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; WOW64; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.5.21022; .NET CLR 3.5.30729; .NET CLR 3.0.30618)",
        "MSIE 8.0"          => "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; FunWebProducts; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.0.04506; InfoPath.1)",
        "Opera 8.0"         => "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; en) Opera 8.0",
        "Opera 9.02"        => "Opera/9.02 (Windows NT 5.1; U; pt-br)",
        "Opera 9.50"        => "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 6.0; en) Opera 9.50",
        "Opera 9.52"        => "Opera/9.52 (Windows NT 6.0; U; Opera/9.52 (X11; Linux x86_64; U); en)",
        "Opera 9.61"        => "Mozilla/5.0 (Windows NT 5.1; U; en-GB; rv:1.8.1) Gecko/20061208 Firefox/2.0.0 Opera 9.61",
        "Opera 9.62"        => "Opera/9.62 (X11; Linux i686; U; en) Presto/2.1.1",
        "Opera 10.00"       => "Opera/9.80 (Windows NT 5.1; U; cs) Presto/2.2.15 Version/10.00",
        "Opera Mobile 9.51" => "Opera/9.51 Beta (Microsoft Windows; PPC; Opera Mobi/1718; U; en)",
        "Opera Mini 9.60"   => "Opera/9.60 (J2ME/MIDP; Opera Mini/4.2.13918/516; U; de) Presto/2.2.0",
        "Safari 3.1"        => "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_2; en-gb) AppleWebKit/526+ (KHTML, like Gecko) Version/3.1 iPhone",
        "Safari 3.2"        => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_5; sv-se) AppleWebKit/525.26.2 (KHTML, like Gecko) Version/3.2 Safari/525.26.12",
        "Safari 4.0"        => "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/528.16 (KHTML, like Gecko) Version/4.0 Safari/528.16",
        "Safari 4.0"        => "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_6; it-it) AppleWebKit/528.16 (KHTML, like Gecko) Version/4.0 Safari/528.16",
        "Safari"            => "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr) AppleWebKit/412.7 (KHTML, like Gecko) Safari/412.5",
        "Safari"            => "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092816 Mobile Safari 1.1.3",
        "Safari"            => "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_1 like Mac OS X; fr-fr) AppleWebKit/525.18.1 (KHTML, like Gecko) Mobile/5F136",
        "Chrome 1.0.154.53" => "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US) AppleWebKit/525.19 (KHTML, like Gecko) Chrome/1.0.154.53 Safari/525.19",
        "Prism 0.8"         => "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9a9pre) Gecko/2007110108 prism/0.8",
        "Prism 0.9"         => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.4; en-US; rv:1.9b4pre) Gecko/2008030313 Prism/0.9",
        "Fluid 0.9.6"       => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_7; de-de) AppleWebKit/528.16 (KHTML, like Gecko) Fluid/0.9.6 Safari/528.16",
        "" => ""
      }
      examples.keys.sort.each do |expected|
        agent = examples[expected]
        UserAgent.new(agent).browser.should == expected
      end
    end
  end
  
  describe '#os' do
    it "should identify os name and version (if available)" do
      examples = {
        "Linux"           => "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.2) Gecko/2008092313 Ubuntu/8.04 (hardy) Firefox/3.1.6",
        "Linux"           => "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092816 Mobile Safari 1.1.3",
        "Mac OS X 10.5.2" => "Mozilla/5.0 (Macintosh; U; PPC Mac OS X 10_5_2; en-gb) AppleWebKit/526+ (KHTML, like Gecko) Version/3.1 iPhone",
        "Mac OS X 10.5.5" => "Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_5_5; sv-se) AppleWebKit/525.26.2 (KHTML, like Gecko) Version/3.2 Safari/525.26.12",
        "Mac OS X"        => "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; fr) AppleWebKit/412.7 (KHTML, like Gecko) Safari/412.5",
        "OpenBSD"         => "Mozilla/5.0 (X11; U; OpenBSD i386; en-US; rv:1.8.1.7) Gecko/20070930 Firefox/2.0.0.7",
        "Windows 2000"    => "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; en) Opera 8.0",
        "Windows 98"      => "Mozilla/5.0 (Windows; U; Win98; de-DE; rv:1.7) Gecko/20040803 Firefox/0.9.3",
        "Windows ME"      => "Mozilla/5.0 (Windows; U; Win 9x 4.90; en-US; rv:1.8.0.3) Gecko/20060426 Firefox/1.5.0.3",
        "Windows Vista"   => "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; WOW64; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.5.21022; .NET CLR 3.5.30729; .NET CLR 3.0.30618)",
        "Windows Vista"   => "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; FunWebProducts; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; .NET CLR 3.0.04506; InfoPath.1)",
        "Windows Vista"   => "Mozilla/5.0 (Windows; U; Windows NT 6.0; de; rv:1.9b5) Gecko/2008032620 Firefox/3.0b5",
        "Windows XP"      => "Mozilla/4.0 (compatible; MSIE 5.5; Windows NT 5.1; .NET CLR 1.1.4322; .NET CLR 2.0.50727)",
        "Windows XP"      => "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.8.1.18) Gecko/20081029 Firefox/2.0.0.18",
        "iPhone 2.1"      => "Mozilla/5.0 (iPhone; U; CPU iPhone OS 2_1 like Mac OS X; fr-fr) AppleWebKit/525.18.1 (KHTML, like Gecko) Mobile/5F136",
        "iPhone 2.2.1"    => "Mozilla/5.0 (iPod; U; CPU iPhone OS 2_2_1 like Mac OS X; de-de) AppleWebKit/525.18.1 (KHTML, like Gecko) Mobile/5H11a",
        "" => ""
      }
      examples.keys.sort.each do |expected|
        agent = examples[expected]
        UserAgent.new(agent).os.should == expected
      end
    end
  end
  
  it "should handle commentless user agents" do
    UserAgent.new("asdf").browser.should == 'asdf'
  end
  
  it "should gracefully handle nil values" do
    UserAgent.new(nil).browser.should == ''
  end

end
