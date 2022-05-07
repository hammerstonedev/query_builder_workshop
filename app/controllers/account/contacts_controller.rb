class Account::ContactsController < Account::ApplicationController
  account_load_and_authorize_resource :contact, through: :team, through_association: :contacts

  # GET /account/teams/:team_id/contacts
  # GET /account/teams/:team_id/contacts.json
  def index
    apply_filter
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @team]
  end

  # GET /account/contacts/:id
  # GET /account/contacts/:id.json
  def show
  end

  # GET /account/teams/:team_id/contacts/new
  def new
  end

  # GET /account/contacts/:id/edit
  def edit
  end

  # POST /account/teams/:team_id/contacts
  # POST /account/teams/:team_id/contacts.json
  def create
    respond_to do |format|
      if @contact.save
        format.html { redirect_to [:account, @team, :contacts], notice: I18n.t("contacts.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @contact] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/contacts/:id
  # PATCH/PUT /account/contacts/:id.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to [:account, @contact], notice: I18n.t("contacts.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @contact] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/contacts/:id
  # DELETE /account/contacts/:id.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @team, :contacts], notice: I18n.t("contacts.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def apply_filter(filter_class = "ContactsFilter")
    if filter_class.constantize.present?
      @stable_id = stable_id
      @refine_filter = if stable_id
        Hammerstone::Refine::Stabilizers::UrlEncodedStabilizer.new.from_stable_id(id: stable_id)
      else
        # e.g. `Scaffolding::CompletelyConcrete::TangibleThingsFilter`
        filter_class.constantize.new([])
      end
      # This will take the @refine_filter object, call get_query, and set the results to @contact
      # instance_variable_set(:@contacts, @refine_filter.get_query)
    end
  end


  def filter_params
    params.permit(:filter, :stable_id, :blueprint, :conditions, :clauses, :name)
  end

  def stable_id
    filter_params[:stable_id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    strong_params = params.require(:contact).permit(
      :email,
      :first_name,
      :last_name,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
