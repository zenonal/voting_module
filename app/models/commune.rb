class Commune < ActiveRecord::Base
  has_many :users
  belongs_to :province
  
  def name
    I18n.translate "C#{self.postal_code}"
  end
  
  def self.reset_postalcodes
    Region.all.each do |r|
      r.destroy
    end
    Province.all.each do |r|
      r.destroy
    end
    Commune.all.each do |r|
      r.destroy
    end
  end
  def self.initialize_postalcodes
    r1=Region.create(:code => 1)
    r2=Region.create(:code => 2)
    r3=Region.create(:code => 3)
    p1 = r3.provinces.create(:code => 1)
    p2 = r2.provinces.create(:code => 2)
    p3 = r2.provinces.create(:code => 3)
    p4 = r2.provinces.create(:code => 4)
    p5 = r2.provinces.create(:code => 5)
    p6 = r1.provinces.create(:code => 6)
    p7 = r1.provinces.create(:code => 7)
    p8 = r1.provinces.create(:code => 8)
    p9 = r1.provinces.create(:code => 9)
    p10 = r2.provinces.create(:code => 10)
    p11 = r2.provinces.create(:code => 11)
    
    communes = YAML::load(File.open("#{RAILS_ROOT}/config/locales/postalcodes/en.yml"))
    c=communes["en"]
    c.each do |cc|
      pc = cc.first
      if pc[0] == "C"
        postal = pc[1..pc.length].to_i
        if postal >= 1000 && postal < 1300
          p1.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 1300 && postal < 1499
          p2.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 1500 && postal < 1999
          p3.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 2000 && postal < 2999
          p4.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 3000 && postal < 3499
          p3.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 3500 && postal < 3999
          p5.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 4000 && postal < 4999
          p6.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 5000 && postal < 5999
          p7.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 6000 && postal < 6599
          p8.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 6600 && postal < 6999
          p9.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 7000 && postal < 7999
          p8.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 8000 && postal < 8999
          p10.communes.find_or_create_by_postal_code(postal)
        end
        if postal >= 9000 && postal < 9999
          p11.communes.find_or_create_by_postal_code(postal)
        end
      end
    end
  end
end
