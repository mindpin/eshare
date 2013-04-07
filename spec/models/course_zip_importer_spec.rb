# -*- coding: utf-8 -*-
require 'spec_helper'

describe CourseZipImporter do
  describe '.import_zip_file' do
    let(:zip_path) {'spec/support/resources/course.zip'}
    let(:creator) {FactoryGirl.create :user}
    let(:course) {Course.find_by_name('zip导入课程')}
    subject {Course.import_zip_file zip_path, creator}

    context 'imports course' do
      it {expect {subject}.to change {Course.count}.by(1)}

      context 'imports chapters' do
        let(:chapters) {course.chapters}

        it {expect {subject}.to change {Chapter.count}.by(2)}
        it 'imports chapters for course' do
          subject
          Chapter.order('created_at desc').limit(2).should =~ chapters
        end

        context 'imports homeworks' do
          it {expect {subject}.to change {Homework.count}.by(3)}
        end

        context 'imports coursewares' do
          it {expect {subject}.to change {CourseWare.count}.by(2)}
        end
      end
    end
  end
end
