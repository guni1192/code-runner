require 'sinatra'
require 'sinatra/reloader' if development?

require_relative 'lib/exec_code_on_docker'

get '/' do
  erb :index
end

get '/exec' do
  r = CodeExecuter.new(Time.now.to_f, 'c')
  r.exec.to_s
end

post '/api/run' do
  lang = params[:language]
  prog = params[:source_code]
  stdin = params[:input]

  time = Time.now.to_f
  p_fname = "#{time}.#{lang.downcase}"  # プログラムファイル
  i_fname = "#{time}.in"                # 標準入力ファイル

  File.open("tmp/#{p_fname}", 'w') do |f|
    prog.split('\n').each do |l|
      f.puts(l)
    end
  end

  # 標準入力を.inファイルに書き込み
  File.open("tmp/#{i_fname}", 'w') do |f|
    stdin.split('\n').each do |l|
      f.puts(l)
    end
  end

  c = CodeExecuter.new(time, lang)

  r = c.exec()

  return_params = {stdout: r[0].join(''), stderr: r[1].join(''), exit_code: r[2]}
  content_type :json
  return_params.to_json
end
