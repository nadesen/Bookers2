class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
    @members = @group.members
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner = current_user
    
    if @group.save
      # Auto-add group owner as member after saving
      @group.members << current_user
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_path, notice: 'Group was successfully deleted.'
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def ensure_owner
    redirect_to groups_path, alert: 'Not authorized.' unless @group.owner == current_user
  end

  def group_params
    params.require(:group).permit(:name, :introduction)
  end
end