module KeepParamsInSession
  def save_last_path
    session[:last_path] = request.env['PATH_INFO'].gsub("index", "")
  end

  def get_last_path
    session[:last_path]
  end


  def keep_params_in_session(label, *keys)
    sess_id_local = request.env['PATH_INFO'].gsub('/index', '')+'_'+label;
    sess_id_global = 'global_'+label;
    keys.each do |key|
      if ((key.is_a? Hash) && key[:global])
        key=key[:global]
        sess_id=sess_id_global
      elsif ((key.is_a? Hash) && key[:key] && key[:depend])
        sess_id=sess_id_global+'_'+params[key[:depend]].to_s
        key=key[:key]
      else
        sess_id=sess_id_local
      end
      params[key] = session["#{sess_id}#{key}"] and logger.debug("restore #{key}=#{params[key]}") if (params[key].nil? && !session["#{sess_id}#{key}"].nil?)
      session["#{sess_id}#{key}"] = params[key] and logger.debug("store #{sess_id}#{key} = #{params[key]}") unless params[key].nil?
    end
  end
end
