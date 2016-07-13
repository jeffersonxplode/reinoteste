class QuizController < ApplicationController

  def index
    @characters = Character.where(user_id: current_user)
    if(@characters.size >= 1)
      @lesson = Lesson.new(lesson_params)
  	  @video = @lesson.url
      session[:questoes] = Question.where(lesson: @lesson.subject).order("RANDOM()").first(5)
      @question = session[:questoes][0]
      puts @question
      puts session[:questoes][0]
      @id = 1
    else
      redirect_to characters_url
    end
  end

  def catalog
    if(@characters.size >= 1)
      @character = Character.where(user_id: current_user).first
      @done_lessons = DoneLesson.where(character_id: @character.id)
    end
  end  
  
  def gerar_quiz
  	
  end

  def ProxPergunta

    @question = Question.where("id = ?", session[:questoes][params[:id].to_i]["id"])
    puts @question.class
    @id = params[:id].to_i + 1
      respond_to do |format|
        format.js
      end

  end


  def answer
    @answer = params[:answer]
    @statement = params[:statement]
    @question = Question.where(statement: @statement).first
    @lesson = Lesson.where(subject: @question.lesson).first
    @character = Character.where(user_id: current_user).first
    @win = false
    @question_answer = @question.a
    @result = 0

    @done_lessons = DoneLesson.where("lesson_id = ? AND character_id = ?", @lesson.id, @character.id).order(id: :asc).first 

    if @done_lesson == nil
      @done_lesson = DoneLesson.new
      @done_lesson.lesson_id = @lesson.id
      @done_lesson.character_id = @character.id
      @done_lesson.score = @result
      @done_lesson.save
      @xp_mult = @result * 10
      @gold_mult = @result * 5 
      @character.correct += @result
      @character.wrong += 5 - @result
      @character.xp += @xp_mult
      @character.gold += @gold_mult
      @win = true
    if @character.xp >= 200 
      @character.xp = 0
      @character.level += 1
    end
      @character.save
    elsif @done_lesson.score < @result
      @done_lesson.score = @result  
      @done_lesson.save
      @xp_mult = @result * 10
      @gold_mult = @result * 5 
      @character.correct += @result
      @character.wrong += 5 - @result
      @character.xp += @xp_mult
      @character.gold += @gold_mult
      @win = true
    if @character.xp >= 200 
      @character.xp = 0
      @character.level += 1
    end
      @character.save
    end

    if @result == 5
      @new_badge = LineBadge.new
      @new_badge.badge_id = 1
      @new_badge.user_id = current_user.id
      @new_badge.earner_email = current_user.email
      @new_badge.save
    end 
    

  end  

  def lesson_params
      params.permit(:subject, :url)
  end

  
end
