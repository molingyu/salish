#encoding: utf-8
#author: shitake
#data: 16-3-27

class Salish::Help

  attr_writer :title
  attr_writer :body
  attr_writer :footer

  def initialize(obj)
    @obj = obj
    @title = @obj.name
    @body = ''
    @footer = ''
  end

  def title
    @title != '' ? "#{@title}\n\n" : ''
  end

  def body
    @body != '' ? "#{@body}\n\n" : ''
  end

  def footer
    @footer != '' ? "#{@footer}\n\n" : ''
  end

  def parameters

    if @obj.commands != []
      obj = @obj.commands.max_by{ |o| o.name.size }
      @commands = "command:\n"
      @obj.commands.each do |cmd|
        space = "\s" * (obj.name.size + 6 - cmd.name.size)
        @commands += "\s\s#{cmd.name}#{space}\s#{cmd.description}\n"
      end
    else
      @commands = ''
    end
    if @obj.options != []
      obj = @obj.options.max_by{ |o| (o[:short] + o[:long]).size }
      size = (obj[:short] + obj[:long]).size
      @options = "option:\n"
      @obj.options.each do |opt|
        space = "\s" * (size + 10 - ("\s\s" + opt[:short] + "\s" + opt[:long]).size)
        @options += "\s\s#{opt[:short]}\s#{opt[:long]}#{space}\s#{opt[:description]}\n"
      end
    else
      @options = ''
    end
    "#{@commands}#{("\n" if @commands != '')}" + \
    "#{@options}#{("\n" if @options != '')}"
  end

  def to_string
    title + body + parameters + footer
  end

end