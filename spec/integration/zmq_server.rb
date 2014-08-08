Thread.abort_on_exception = true

def error_check(rc)
  if ZMQ::Util.resultcode_ok?(rc)
    false
  else
    #STDERR.puts "Operation failed, errno [#{ZMQ::Util.errno}] description [#{ZMQ::Util.error_string}]"
    #caller(1).each { |callstack| STDERR.puts(callstack) }
    true
  end
end

def create_context
  ZMQ::Context.create
end

def kill_context(context)
  context.terminate
end

def run_reply_server(context,rep_sock,rc,reply_type = 'normal')

  #STDERR.puts "Failed to create a Context" unless context

  case reply_type
  when 'always_succeed'
    @replies = {:success => "200", :retry => "200", :failure => "200"}
  when 'always_retry'
    @replies = {:success => "409", :retry => "409", :failure => "409"}
  when 'always_fail'
    @replies = {:success => "500", :retry => "500", :failure => "500"}
  else
    @replies = {:success => "200", :retry => "409", :failure => "500"}
  end

  Thread.new do
    #rep_sock = context.socket(ZMQ::REP)
    #rc = rep_sock.bind('tcp://127.0.0.1:2200')
    #error_check(rc)

    while ZMQ::Util.resultcode_ok?(rc)
      message = []
      rc = rep_sock.recv_strings(message)

      break if error_check(rc)
      rc = rep_sock.send_string(@replies[:success])

      break if error_check(rc)
    end

    error_check(rep_sock.close)
  end
end

def stop_server(thread)
  Thread.kill(thread)
  kill_context
end

