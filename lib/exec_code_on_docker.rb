require 'docker-api'

class CodeExecuter
  def initialize(time, lang)
    @lang = lang
    @time = time

    @container = Docker::Container.create(
      name: "#{time}-exec-container",
      Image: 'code_runner',
      HostConfig: {
        # ホストのtmpをコンテナの/tmpにバインド
        Binds: [
          "#{File.expand_path('tmp')}:/tmp"
        ]
      },
      Workdir: '/tmp',
      Tty: true
    )
  end

  def exec
    compile_cmd = chooseLang

    @container.start

    r = @container.exec(['bash','-c', "cd /tmp && #{compile_cmd} < #{@time}.in", "pwd"])
    puts("r = #{r}")

    @container.stop
    @container.delete(force: true)

    return r
  end

  def chooseLang
    case @lang.downcase
    when 'c' then
      return "gcc -o #{@time} #{@time}.c && ./#{@time}"
    when 'ruby' then
      return "ruby #{@time}.ruby"
    when 'python' then
      return "python3 #{@time}.python"
    else
      return ''
    end
  end
end
