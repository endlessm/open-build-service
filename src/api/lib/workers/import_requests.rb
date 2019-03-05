class ImportRequestsDelayedJob
  def initialize
  end

  def perform
    require 'opensuse/backend'

    lastrq = Suse::Backend.get("/request/_lastid").body.to_i
    while lastrq > 0
      begin
        xml = Suse::Backend.get( "/request/#{lastrq}" ).body
      rescue ActiveXML::Transport::Error => err
        Rails.logger.error "Request ##{lastrq} could not be retrieved:\n#{err}"
        lastrq -= 1
        next
      end
      r = BsRequest.new_from_xml xml
      begin
        if r.save
          Rails.logger.info "Request ##{lastrq} imported"
        else
          Rails.logger.error "Request ##{lastrq} could not be saved:\n%s" \
                             % r.errors.full_messages.join("\n")
        end
      rescue ActiveRecord::RecordNotUnique
        Rails.logger.debug "Request ##{lastrq} already imported"
      end
      lastrq -= 1
    end
  end
end
