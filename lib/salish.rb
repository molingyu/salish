require "salish/version"

module Salish

  class << self

    def version_str?(ver_str)
      /\d*\.\d*\.\d*/ === ver_str
    end

    def error(str)
      puts str
    end

  end

  class Help

    attr_accessor :title
    attr_accessor :body
    attr_accessor :footer

    def initialize(obj)
      @obj = obj
      @title = @obj.name
      @body = ''
      @footer = ''
      @options = "option:\n"
      @commands = "command:\n"
    end

    def parameters
      @obj.commands.each{ |cmd| @commands += "\s"*2 + cmd.name + "\s"*(20 - cmd.name.size) + cmd.description + "\n" } if @obj.commands != []
      @obj.options.each{ |opt| @options += "\s"*2 + opt[:short] + "\s" + opt[:long] + "\s"*(20 - ("\s"*2 + opt[:short] + "\s" + opt[:long]).size) + "\s"*2 + opt[:description] + "\n" } if @obj.options != []
      @commands + "\n" + @options
    end

    def to_s
      title + "\n\n" + body + "\n\n" + parameters + "\n" + footer
    end

  end

  class Command

    attr_reader :name
    attr_reader :commands
    attr_reader :options
    attr_accessor :parent
    attr_accessor :description
    def initialize(name = 'root')
      @name = name
      @help = Help.new(self)
      @parent = self
      @version = ''
      @options = []
      @commands = []
      @description = ''
      help_opt = {
          :short => '-h',
          :long => '--help',
          :params => nil,
          :description => 'Print help info',
          :callback => lambda{ puts @help.to_s; p 233 }
      }
      @options.push(help_opt)
    end

    def version(ver_str)
      raise "version error!(#{ver_str})" unless Salish.version_str?(ver_str)
      @version = ver_str
      version_opt = {
          :short => '-v',
          :long => '--version',
          :params => nil,
          :description => 'Print version info',
          :callback => lambda{ puts @version }
      }
      @options.push(version_opt)
      self
    end
    # ('-a, --b', 's:string, n:times, b:false', ''){}
    def option(flags, description, params = nil, &callback)
      list = []
      flags.split(',').each{|flag| list.push flag.strip}
      flags_short = list[0]
      flags_long = list[1]
      if params
        list = []
        params.split(',').each do |param|
          param = param.split(':')
          
          if param.size == 2
            type = param[0]
            name = param[1]
          else
            type = 'string'
            name = param[0]
          end
          list << {:type => type, :name => name}
        end
      else
        list = nil
      end

      opt = {
          :short => flags_short,
          :long => flags_long,
          :params => list,
          :description => description,
          :callback => callback
      }
      @options.push(opt)
      self
    end

    def command(name, description, version = nil)
      cmd = Command.new(name)
      cmd.parent = self
      cmd.description = description
      cmd.version(version || @version)
      @commands.push(cmd)
      cmd
    end

    def help(&block)
      yield @help
      self
    end

    def parse(arvg)
      #arvg.split('s')
      opt = arvg[0]
      param = arvg[1, arvg.size] || []
      return call_opt('long', opt, param) if /--.*/ === opt
      return call_opt('short', opt, param) if /-.*/ === opt
      call_cmd(opt, param)
    end

    private
    # 调用参数
    def call_opt(type, option, params)
      @options.each do |opt|
        opt_name = (type == 'long' ? opt[:long] : opt[:short])
        if option == opt_name
          if opt[:params]
            return opt[:callback].call(opt_set_params(opt, params))
          else

            return opt[:callback].call
          end
        end
      end
      Salish.error('25555')
    end

    def opt_set_params(opt, params)
      param = {}
      Salish.error('26666') unless opt[:params].size <= params.size
      opt[:params].each_with_index do |opt_par, i|
        case opt_par[:type]
          when 'string'
            param[opt_par[:name].to_sym] = params[i]
          when 'integer'
            param[opt_par[:name].to_sym] = params[i].to_i
          when 'float'
            param[opt_par[:name].to_sym] = params[i].to_f
          when 'symbol'
            param[opt_par[:name].to_sym] = params[i].to_sym
          else
            Salish.error('24444')
        end
      end
      param
    end

    # 调用子命令
    def call_cmd(command, arvg)
      @commands.each do |cmd|
        if command == cmd.name
          return cmd.parse(arvg)
        end
      end
      Salish.error('21111')
    end

  end

end




cmd = Salish::Command.new

cmd
    .version('1.0.1')
    .help do |h|
  h.title = 'Test Command'
  h.body = 'hahaha,this is a test command!'
  h.footer = "exemple:\n\thahaaha"
end
    .option('-a, --add', 'add all file,and from path.', 'string:path') do |p|
  puts p[:path]
end
    .option('-l, --list', 'list'){ puts 'this is a list' }
    .command('push', 'tinajiawuping')
    .option('-a, --all', 'suoyoudedoutianjia') { puts 'all' }

#p cmd.options

cmd.parse(ARGV)