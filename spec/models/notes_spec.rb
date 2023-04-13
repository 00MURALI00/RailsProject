require 'rails_helper'

RSpec.describe Note, type: :model do
  describe 'association' do
    context 'belongs to' do
      it 'course' do
        note = create(:note)
        course = create(:course)
        note.course = course
        expect(note.course).to eq(course)
      end
    end
  end
  describe 'note' do
    context 'presence' do
      it 'not valid' do
        note = build(:note, description: nil)
        note.validate
        expect(note.errors).to include(:description)
      end
      it 'valid' do
        note = build(:note)
        note.validate
        expect(note.errors).not_to include(:description)
      end
    end
  end

  describe 'scope' do
    context 'published' do
      it 'valid' do
        note = create(:note)
        expect(Note.published).to include(note)
      end
      it 'not valid' do
        note = create(:note, published_at: nil)
        expect(Note.published).not_to include(note)
      end
    end
    context 'unpublished' do
      it 'valid' do
        note = create(:note, published_at: nil)
        expect(Note.unpublished).to include(note)
      end
      it 'not valid' do
        note = create(:note)
        expect(Note.unpublished).not_to include(note)
      end
    end
  end
end