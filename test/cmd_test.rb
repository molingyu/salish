#encoding: utf-8
#author: shitake
#data: 16-3-26

require '../lib/salish'

cmd = Salish::Command.new('test')
cmd.version('1.0.1')

cmd.help do |h|
  h.body = '这是一个控制台命令的测试命令。你可以通过-h或者--help来查看帮助！'
  h.footer = \
  "用例:\n"\
  "  载入模块:\n\trequire 'salish'\n"\
  "  创建根命令:\n\tcmd = Salish.cmd\n"\
  "  设置版本:\n\tcmd.version('1.1.1')\n"\
  "  添加参数:\n\tcmd.option('-a, --add', '添加文件', 'string:path'){|param| puts '文件路径',param[:path] }\n"
end

cmd.option('-a, --add', '<s:path> 从指定路径载入文件。', 'string:path') do |p|
  puts '文件路径：',p[:path]
end

cmd.option('-l, --list', '列出现有文件'){ puts "index.html\s\sconf.txt" }

push = cmd.command('push', '上传文件')
push.option('-a, --all', '是否上传全部') { puts '所有文件都已上传！' }

# cmd.parse(%w(-v))
# cmd.parse(%w(-h))
# cmd.parse(%w'push -h')
cmd.parse(%w'-add')
