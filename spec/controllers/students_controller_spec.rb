require 'spec_helper'

describe Admin::UsersController do
  let(:teacher) {FactoryGirl.create(:user, :teacher)}
  let(:student) {FactoryGirl.create(:user, :student)}

  context 'student extra info' do
    describe 'GET student_attrs' do
      context 'when passed a teacher\'s id' do
        it 'redirects to admin root' do
          get :student_attrs, id: teacher.id
          response.should redirect_to admin_root_path
        end
      end

      context 'when passed a student\'s id' do
        it 'displays a form for extra teacher info' do
          get :student_attrs, id: student.id
          response.should render_template :student_attrs
        end
      end
    end

    describe 'PUT user_attrs_update' do
      it 'updates a user\'s extra info' do
        put :user_attrs_update, id: student.id, user: {}
        response.should redirect_to student_attrs_admin_user_path(student)
      end
    end
  end

  context 'teacher extra info' do
    describe 'GET teacher_attrs' do
      context 'when passed a student\'s id' do
        it 'redirects to admin root' do
          get :teacher_attrs, id: student.id
          response.should redirect_to admin_root_path
        end
      end

      context 'when passed a teacher\'s id' do
        it 'displays a form for extra teacher info' do
          get :teacher_attrs, id: teacher.id
          response.should render_template :teacher_attrs
        end
      end
    end

    describe 'PUT user_attrs_update' do
      it 'updates a user\'s extra info' do
        put :user_attrs_update, id: teacher.id, user: {}
        response.should redirect_to teacher_attrs_admin_user_path(teacher)
      end
    end
  end
end