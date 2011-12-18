class RegistrationsController < Devise::RegistrationsController

        def create
                begin
                        super
                        session[:omniauth] = nil unless @user.new_record?
                        if params[:postal_code]
                                c = Commune.find_by_postal_code(params[:postal_code])
                                if c
                                        s1 = @user.update_attribute(:commune_id, c.id)
                                        s2 = @user.update_attribute(:province_id, c.province.id)
                                        s3 = @user.update_attribute(:region_id, c.province.region.id)
                                end
                        end
                        if @user.uploadedPhoto?
                                @user.update_attribute(:photo, @user.uploadedPhoto.url("small"))
                        end

                rescue ActiveRecord::RecordNotUnique
                        flash[:notice] = t('errors.messages.not_unique')
                        redirect_to root_url
                end
        end

        def update

                # Devise use update_with_password instead of update_attributes.
                # This is the only change we make.
                if current_user.authentications.empty?
                        r = resource.update_with_password(params[resource_name])
                else
                        r = resource.update_attributes(params[resource_name])
                end
                if r
                        s= true
                        if params[:postal_code]
                                c = Commune.find_by_postal_code(params[:postal_code])
                                if c
                                        s1 = current_user.update_attribute(:commune_id, c.id)
                                        s2 = current_user.update_attribute(:province_id, c.province.id)
                                        s3 = current_user.update_attribute(:region_id, c.province.region.id)
                                end
                        end
                        if current_user.uploadedPhoto?
                                current_user.update_attribute(:photo, current_user.uploadedPhoto.url("small"))
                        else
                                if current_user.photo.nil? 
                                        current_user.update_attribute(:photo, "images/unknownUser.jpg")
                                end
                        end
                        set_flash_message :notice, :updated
                        # Line below required if using Devise >= 1.2.0
                        sign_in resource_name, resource, :bypass => true
                        redirect_to after_update_path_for(resource)
                else
                        clean_up_passwords(resource)
                        render_with_scope :edit
                end
        end

        private
        def build_resource(*args)
                super
                if session[:omniauth]
                        @user.apply_omniauth(session[:omniauth])
                        @user.valid?
                end
        end
end
