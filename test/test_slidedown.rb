require File.join(File.dirname(__FILE__), 'helper')

describe 'SlideDown' do
  extend TestHelp

  it 'finds slides' do
    with_markdown <<-MD
    |# First
    |
    |!SLIDE
    |
    |# Second
    MD
    slidedown.slides.length.should.equal(2)
  end

  it 'generates HTML from markdown' do
    with_markdown <<-MD
    |!SLIDE
    |# The title
    |!SLIDE
    MD
    Nokogiri::HTML(slidedown.render).at('h1').should.not.be.nil
  end

  it 'adds class names to slides' do
    with_markdown <<-MD
    |# This is the title
    |!SLIDE awesome
    |# The title
    MD
    second_slide = Nokogiri::HTML(slidedown.render).search('#track > div')[1]
    second_slide['class'].strip.should.equal('awesome')
  end

  it 'deals with white space after class names' do
    with_markdown <<-MD
    |# first slide
    |!SLIDE code
    |
    |    def foo
    |      :bar
    |    end
    MD
    second_slide = Nokogiri::HTML(slidedown.render).search('#track > div')[1]
    second_slide['class'].strip.should.equal('code')
  end

  # this one is hard
  it 'allows custom lexer' do
    with_markdown <<-MD
    |@@@ js
    |  (function() { })();
    |@@@
    MD
    # slidedown.render
    Nokogiri(slidedown.render).at('.highlight.js').should.not.be.nil
  end
end
