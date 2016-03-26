#encoding: utf-8
#author: shitake
#data: 16-3-26

class Salish::Command

  attr_reader :name
  attr_reader :commands
  attr_reader :options
  attr_accessor :parent
  attr_accessor :description
  def initialize(name = 'root')
    @name = name
    @help = Salish::Help.new(self)
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
        :callback => lambda{ puts @help.to_s }
    }
    @options.push(help_opt)
  end

  # raise "version error!(#{ver_str})"
  def version(ver_str)
     Salish.error('') unless Salish.version_str?(ver_str)
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
    flags.split(',').each{|flag| list << flag.strip}
    flags_short = list[0]
    flags_long = list[1]
    if params
      list = []
      params.split(',').each do |param|
        param = param.split(':')
        #type = name = ''
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
    cmd = Salish::Command.new(name)
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
    Salish.error('')
  end

end
