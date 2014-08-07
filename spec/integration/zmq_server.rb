Thread.abort_on_exception = true

def error_check(rc)
  if ZMQ::Util.resultcode_ok?(rc)
    false
  else
    STDERR.puts "Operation failed, errno [#{ZMQ::Util.errno}] description [#{ZMQ::Util.error_string}]"
    caller(1).each { |callstack| STDERR.puts(callstack) }
    true
  end
end

def run_reply_server
  ctx = ZMQ::Context.create(1)
  STDERR.puts "Failed to create a Context" unless ctx

  Thread.new do
    rep_sock = ctx.socket(ZMQ::REP)
    rc = rep_sock.bind('tcp://127.0.0.1:2200')
    error_check(rc)

    message = []
    while ZMQ::Util.resultcode_ok?(rc)
      rc = rep_sock.recv_strings(message)
      break if error_check(rc)

      rc = rep_sock.send_string("Received request '#{message.inspect}'")
      message = []
      break if error_check(rc)
    end

    error_check(rep_sock.close)
  end
end
