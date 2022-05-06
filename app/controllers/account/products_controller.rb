class Account::ProductsController < Account::ApplicationController
  account_load_and_authorize_resource :product, through: :contact, through_association: :products

  # GET /account/contacts/:contact_id/products
  # GET /account/contacts/:contact_id/products.json
  def index
    # if you only want these objects shown on their parent's show page, uncomment this:
    # redirect_to [:account, @contact]
  end

  # GET /account/products/:id
  # GET /account/products/:id.json
  def show
  end

  # GET /account/contacts/:contact_id/products/new
  def new
  end

  # GET /account/products/:id/edit
  def edit
  end

  # POST /account/contacts/:contact_id/products
  # POST /account/contacts/:contact_id/products.json
  def create
    respond_to do |format|
      if @product.save
        format.html { redirect_to [:account, @contact, :products], notice: I18n.t("products.notifications.created") }
        format.json { render :show, status: :created, location: [:account, @product] }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account/products/:id
  # PATCH/PUT /account/products/:id.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to [:account, @product], notice: I18n.t("products.notifications.updated") }
        format.json { render :show, status: :ok, location: [:account, @product] }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account/products/:id
  # DELETE /account/products/:id.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to [:account, @contact, :products], notice: I18n.t("products.notifications.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    strong_params = params.require(:product).permit(
      :name,
      # 🚅 super scaffolding will insert new fields above this line.
      # 🚅 super scaffolding will insert new arrays above this line.
    )

    # 🚅 super scaffolding will insert processing for new fields above this line.

    strong_params
  end
end
