# -*- encoding : utf-8 -*-
class MailsController < ApplicationController
  # GET /mails
  # GET /mails.xml
  before_filter :login_required
  before_filter :character_required
  before_filter :find_mail, :only => [:show, :edit, :update, :destroy]
  
  def index
    @mails = current_character.mails.all
  
    respond_to do |format|
      format.html # index.html.erb
      format.js { render :json => @mails }
      format.xml  { render :xml => @mails }
    end
  end

  # GET /mails/1
  # GET /mails/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mail }
    end
  end

  # GET /mails/new
  # GET /mails/new.xml
  def new
    @mail = Mail.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mail }
    end
  end

  # GET /mails/1/edit
  def edit
  return
    
  end

  # POST /mails
  # POST /mails.xml
  def create
    @mail = Mail.new(params[:mail])

    respond_to do |format|
      if @mail.save
        flash[:notice] = 'Mail was successfully created.'
        format.html { redirect_to(@mail) }
        format.xml  { render :xml => @mail, :status => :created, :location => @mail }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mails/1
  # PUT /mails/1.xml
  def update
  return
    

    respond_to do |format|
      if @mail.update_attributes(params[:mail])
        flash[:notice] = 'Mail was successfully updated.'
        format.html { redirect_to(@mail) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mail.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mails/1
  # DELETE /mails/1.xml
  def destroy
    
    @mail.destroy

    respond_to do |format|
      format.html { redirect_to(mails_url) }
      format.xml  { head :ok }
    end
  end
  protected
  def find_mail
    @mail = current_character.mails.find(params[:id])
  end
end
