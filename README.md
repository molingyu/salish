# Salish

一个类似 `commander` 的ruby的命令行工具。用于快速生成命令。支持多级子命令创建。

## Installation

Add this line to your application's Gemfile:

    gem 'salish'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install salish --pre

## Usage
#### 载入库并创建命令
````
require 'salish'
cmd_obj = Salish.cmd
````

#### 设置版本信息
````
cmd_obj.version('0.0.1')
````
#### 编写帮助信息(可选)
````
cmd_obj.help do |help|
  #设置帮助的标题
  help.title = ''
  #设置帮助的主体
  help.body = ''
  #设置帮助的尾部
  help.footer = ''
````
子命令及参数的帮助会自动生成。关于帮助输出的顺序是：
    
    title -> body -> 子命令和参数 -> footer

#### 设置option(可选、任意数目)
````
cmd_obj.option(options, info, <param_info>, <&block>)
````
options(`string`)：描述短参数及长参数，会出现在自动生成的帮助信息里。
info(`string`)：参数的描述信息。会出现在自动生成的帮助信息里。
param_info(`string`)：固定参数描述。格式为： `param__type:param__name` ,多个参数用 `,` 分开。
block(`proc`)：该参数执行的相应动作。如果有固定参数，则可以通过 `do |param| ... end` 的形式来获得。`param` 为一个哈希表，键为 `param_info` 里的 `param__name`，类型为 `symbol`。

#### 设置子命令(可选、任意数目)
````
cmd_obj.command(cmd_name, info, version)
````
cmd_name(`string`)：子命令名
info(`string`)：子命令说明，该说明会出现在父命令自动生成的帮助信息里。
version(`string`)：可选，不填写时，版本信息等同于父命令。

#### 解析命令
````
cmd_obj.parse(ARGV)
````
请确保该方法最后调用。处于该方法之后添加的命令/参数等无效。

### 注意事项
1. 对于 `version`/`option`/`help` 这些方法来说，最后的返回值均为对象本身。而 `command` 会返回创建的子命令对象。
2. 如果 `version` 的调用在 `command` 之后，创建子命令时如果不传入版本参数，这时版本信息会出错（父命令的版本信息为空字符串）。

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
