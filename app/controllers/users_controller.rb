class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update]
  before_action :authenticate_user!, only: [:following, :followers]
  before_action :ensure_guest_user,only:[:edit]


  def show
    @user = User.find(params[:id])
    @books = @user.books
    @today_books = @books.created_today
    @yesterday_books = @books.created_yesterday
    if @yesterday_books.count == 0
      @compared_day = "+"
    else
      @compared_day = (@today_books.count / @yesterday_books.count) * 100
    end
    @week_books = @books.created_week
    @lastweek_books = @books.created_lastweek
    if @lastweek_books.count == 0
      @compared_week = "+"
    else
      @compared_week = (@week_books.count / @lastweek_books.count) * 100
    end
    @book = Book.new
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user=User.find(params[:id])
    unless @user==current_user
      redirect_to user_path(current_user)
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ensure_guest_user
    @user=User.find(params[:id])
    if @user.name=="guestuser"
      redirect_to user_path(current_user),notice:"ゲストユーザーはプロフィール編集画面に遷移できません。"
    end
  end




end
