class PracticeCreatorsController < ApplicationController
    before_action :set_practice

    # Alter practice creator positioning
    def sort
        debugger
        params[:practice_creators].each_with_index do |id, index|
           PracticeCreator.where(id: id, practice_id: @practice.id).update_all(position: index + 1)
        end
        respond_to do |format|
            format.js
        end
    end

    private

    def set_practice
        id = params[:id] || params[:practice_id]
        @practice = Practice.friendly.find(id)
    end
end