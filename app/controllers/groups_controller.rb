class GroupsController < ApplicationController
  def index
    @groups = Queries::ExploreGroups.new.search_for(params[:q]).where.not(name: nil).order('groups.memberships_count DESC')
    @total = @groups.count
    limit = 2
    if @total < limit
      @pages = 1
    else
      if @total % limit > 0
        @pages = @total / limit + 1
      else
        @pages = @total / limit
      end
    end
    @page = params.fetch(:page, 1).to_i.clamp(1, @pages)
    @offset = @page == 1 ? 0 : ((@page - 1) * limit)
    @groups = @groups.limit(limit).offset(@offset)
  end

  def export
    @exporter = GroupExporter.new(load_and_authorize(:formal_group, :export))

    respond_to do |format|
      format.html
      format.csv { send_data @exporter.to_csv }
    end
  end
end
