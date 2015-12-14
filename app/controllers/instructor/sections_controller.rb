class Instructor::SectionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorization_for_current_course, :only => [:update]
  before_action :require_authorization_for_current_section, :only => [:update]

  def new
    @section = Section.new
  end

  def create
    @section = current_course.sections.create(section_params)
    redirect_to instructor_course_path(current_course)
  end

  def update
    current_section.update_attributes(section_params)
    render :text => 'Updated!'
  end

  private

  def require_authorization_for_current_section
    if current_section.course.user != current_user
      render :text => 'Unauthorization', :status => :unauthorization
    end
  end

  def current_section
    @current_section ||= Section.find(params[:id])
  end

  def require_authorization_for_current_course
    if current_course.user != current_user
      render :text => "Unauthorization", :status => :unauthorization
    end
  end

 helper_method :current_course
    def current_course
    current_section.course
  end

  def section_params
    params.require(:section).permit(:title)
  end
end