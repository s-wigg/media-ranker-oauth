require 'test_helper'

describe Vote do
  describe "relations" do
    it "has a user" do
      v = votes(:one)
      v.must_respond_to :user
      v.user.must_be_kind_of User
    end

    it "has a work" do
      v = votes(:one)
      v.must_respond_to :work
      v.work.must_be_kind_of Work
    end
  end

  describe "validations" do
    let(:dan) { users(:dan) }

    let (:user1) { User.new(username: 'chris', uid: 1000, provider: 'github') }
    let (:user2) { User.new(username: 'chris', uid: 1001, provider: 'github') }
    let (:work1) { Work.new(category: 'book', title: 'House of Leaves', user: dan) }
    let (:work2) { Work.new(category: 'book', title: 'For Whom the Bell Tolls', user: dan) }

    it "allows one user to vote for multiple works" do
      vote1 = Vote.new(user: user1, work: work1)
      vote1.save!
      vote2 = Vote.new(user: user1, work: work2)
      vote2.valid?.must_equal true
    end

    it "allows multiple users to vote for a work" do
      vote1 = Vote.new(user: user1, work: work1)
      vote1.save!
      vote2 = Vote.new(user: user2, work: work1)
      vote2.valid?.must_equal true
    end

    it "doesn't allow the same user to vote for the same work twice" do
      vote1 = Vote.new(user: user1, work: work1)
      vote1.save!
      vote2 = Vote.new(user: user1, work: work1)
      vote2.valid?.must_equal false
      vote2.errors.messages.must_include :user
    end
  end
end
