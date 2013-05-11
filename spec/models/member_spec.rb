require 'spec_helper'

describe Member do

  it "should have a valid factory" do
    FactoryGirl.build( :member ).should be_valid
  end

  it "should have a valid factory with fully populated contact info" do
    m = FactoryGirl.create( :member_with_contact_info )
    m.should be_valid
    m.email_addresses.should_not be_empty
    m.phone_numbers.should_not be_empty
    m.addresses.should_not be_empty
  end

  it "should have many addresses" do
    m = FactoryGirl.build( :member )
    m.should have_many( :addresses )
  end

  it "should have a valid factory with addresses" do
    m = FactoryGirl.create( :member_with_addresses )
    m.should be_valid
    m.addresses.should_not be_empty
  end

  it "should have many email addresses" do
    m = FactoryGirl.build( :member )
    m.should have_many( :email_addresses )
  end

  it "should have a valid factory with email addresses" do
    m = FactoryGirl.create( :member_with_emails )
    m.should be_valid
    m.email_addresses.should_not be_empty
  end

  it "should destroy phone numbers when it is destroyed" do
    m = FactoryGirl.create( :member_with_phone_numbers )
    pid = m.phone_numbers.last.id
    m.destroy
    PhoneNumber.exists?( pid ).should_not be_true
  end

  it "should have many phone numbers" do
    m = FactoryGirl.build( :member )
    m.should have_many( :phone_numbers )
  end

  it "should have a valid factory with phone numbers" do
    m = FactoryGirl.create( :member_with_phone_numbers )
    m.should be_valid
    m.phone_numbers.should_not be_empty
  end

  it "should destroy email addresses when it is destroyed" do
    m = FactoryGirl.create( :member_with_emails )
    eid = m.email_addresses.last.id
    m.destroy
    EmailAddress.exists?( eid ).should_not be_true
  end

  describe '#valid?' do
    it "should validate gender against GENDER constant values" do
      m = FactoryGirl.build( :member, :gender => Member::GENDER[ :male ] )
      m.should be_valid
      m.gender = 'abcdefg'
      m.should_not be_valid
      m.errors.should include( :gender )
    end

    it "should require first_name" do
      m = FactoryGirl.build( :member, :first_name => nil )
      m.should_not be_valid
      m.errors.should include( :first_name )
    end

    it "should require last_name" do
      m = FactoryGirl.build( :member, :last_name => nil )
      m.should_not be_valid
      m.errors.should include( :last_name )
    end

    it "should not require middle name" do
      m = FactoryGirl.build( :member, :middle_name => nil )
      m.should be_valid
    end

    it "should require a birthdate" do
      m = FactoryGirl.build( :member, :birthdate => nil )
      m.should_not be_valid
      m.errors.should include( :birthdate )
    end

    it "should require a birthdate in the past" do
      m = FactoryGirl.build( :member, :birthdate => 2.years.from_now.to_date )
      m.should_not be_valid
      m.errors.should include( :birthdate )
    end

  end


end
