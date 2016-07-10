class Api::V1::QuestionsController < ApplicationController
    def index
        @questions = Question.all
        respond_to do |format|
            format.json { render :json => @questions}
        end
    end
end
