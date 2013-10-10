require "spec_helper"

describe KnowledgeQuestionPost do
  let(:reply) {FactoryGirl.create :knowledge_question_post_comment, :reply}
  let(:comment) {reply.reply_comment}
  let(:post) {comment.knowledge_question_post}
  let(:question) {post.knowledge_question}

  specify {comment.reply_comments.size.should be 1}
  specify {post.main_comments.size.should be 1}
  specify {question.posts.size.should be 1}
end
