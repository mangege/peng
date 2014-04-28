# -*- encoding : utf-8 -*-
class SalesController < ApplicationController
  load_and_authorize_resource

  # GET /sales
  # GET /sales.xml
  def index
    @sales = Sale.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @sales }
    end
  end

  # GET /sales/1
  # GET /sales/1.xml
  def show
    @sale = Sale.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @sale }
    end
  end

  # GET /sales/new
  # GET /sales/new.xml
  def new
    @sale = Sale.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @sale }
    end
  end

  # GET /sales/1/edit
  def edit
    @sale = Sale.find(params[:id])
  end

  # POST /sales
  # POST /sales.xml
  def create
    @sale = Sale.new(params[:sale])

    respond_to do |format|
      if @current_user.role? :employee
        @sale.user = @current_user
        @sale.store_id = @current_user.store_id
        if @sale.save
          format.html { redirect_to(list_month_sales_path, :notice => '添加成功') }
          format.xml { render :xml => @sale, :status => :created, :location => @sale }
        else
          format.html { render :action => "new" }
          format.xml { render :xml => @sale.errors, :status => :unprocessable_entity }
        end
      else
        @sale.errors.add_to_base '请用雇员帐号登陆进行此操作'
        format.html { render :action => "new" }
        format.xml { render :xml => @sale.errors, :status => :unprocessable_entity }
      end

    end
  end

  # PUT /sales/1
  # PUT /sales/1.xml
  def update
    @sale = Sale.find(params[:id])

    respond_to do |format|
      if @sale.update_attributes(params[:sale])
        format.html { redirect_to(sale_path(@sale), :notice => '更新成功.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @sale.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1
  # DELETE /sales/1.xml
  def destroy
    @sale = Sale.find(params[:id])
    @sale.destroy

    respond_to do |format|
      format.html { redirect_to(list_admin_sales_path) }
      format.xml { head :ok }
    end
  end

  def list_month
    @current_date = Date.current
    @current_date = @current_date.prev_month if params[:month] == "prev"
    @sales = Sale.find(:all,
                       :conditions => ["store_id=? and sale_time>=? and sale_time<=?", current_user.store_id, @current_date.beginning_of_month, @current_date.end_of_month],
                       :order => "sale_time asc")
    sum_data
    respond_to do |format|
      format.html # index.html.erb
      format.xml { render :xml => @sales }
    end
  end

  def list_admin
    @current_date = Date.current
    @current_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, 1) unless params[:date].nil?
    if params[:store_id].nil?
      @store_id = Store.all().first.id
    else
      @store_id = params[:store_id]
    end
    @sales = Sale.find(:all, :conditions => ["store_id=? and sale_time>=? and sale_time<=?", @store_id, @current_date.beginning_of_month, @current_date.end_of_month],
                       :order => "sale_type asc,sale_time asc")

    if params[:commit].nil? or params[:commit] == "查询"
      sum_data
      respond_to do |format|
        format.html
        format.xml { render :xml => @sales }
      end
    elsif params[:commit] == "导出"
      render :layout=>nil,:file => "#{Rails.root}/public/403.html", :status => 403 and return unless current_user.admin?
      send_file(export_write_data(@sales, Store.find(@store_id), @current_date))
    end

  end

  def list_summary
    @current_date = Date.current
    @current_date = Date.new(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i) unless params[:date].nil?

    #外销
    str_sql_cols = "store_id AS store_id, SUM(pt) AS pt, SUM(gold) AS gold, SUM(gold_jade) AS gold_jade, SUM(color_stone) AS color_stone, SUM(inlay) AS inlay, SUM(kgold) AS kgold, SUM(other) AS other, SUM(old_gold) AS old_gold, SUM(old_pt) AS old_pt, SUM(day) AS day "
    @sum_days = Sale.group("store_id").where(:sale_time => @current_date, :sale_type => 1).select(str_sql_cols)
    @sum_months = Sale.group("store_id").where(:sale_time => @current_date.beginning_of_month..@current_date.end_of_month, :sale_type => 1).select(str_sql_cols)
    @sum_years = Sale.group("store_id").where(:sale_time => @current_date.beginning_of_year..@current_date.end_of_year, :sale_type => 1).select(str_sql_cols)

    #内销
    @sum_days2 = Sale.group("store_id").where(:sale_time => @current_date, :sale_type => 2).select(str_sql_cols)
    @sum_months2 = Sale.group("store_id").where(:sale_time => @current_date.beginning_of_month..@current_date.end_of_month, :sale_type => 2).select(str_sql_cols)
    @sum_years2 = Sale.group("store_id").where(:sale_time => @current_date.beginning_of_year..@current_date.end_of_year, :sale_type => 2).select(str_sql_cols)

    @stores = Store.all
  end

  private
  def sum_data
    @month_sum = @inlay_sum = @pt_sum = @gold_sum = @kgold_sum = @other_sum = @old_gold_sum = @old_pt_sum  = @gold_jade_sum = @color_stone_sum = 0
    msales = @sales.select { |ms| ms.sale_type == 1 } #外销
    msales.each do |msale|
      unless msale.nil?
        @month_sum += msale.day
        @inlay_sum += msale.inlay
        @pt_sum += msale.pt
        @gold_sum += msale.gold
        @kgold_sum += msale.kgold
        @other_sum += msale.other
        @old_gold_sum += msale.old_gold
        @old_pt_sum += msale.old_pt
        @gold_jade_sum += msale.gold_jade
        @color_stone_sum += msale.color_stone
      end
    end
    @new_material_month_sum = @inlay_sum + @pt_sum + @gold_sum + @kgold_sum + @other_sum + @gold_jade_sum + @color_stone_sum
    @old_material_month_sum = @old_gold_sum + @old_pt_sum

    @month_sum2 = @inlay_sum2 = @pt_sum2 = @gold_sum2 = @kgold_sum2 = @other_sum2 = @old_gold_sum2 = @old_pt_sum2 = @gold_jade_sum2 = @color_stone_sum2 = 0
    msales = @sales.select { |ms| ms.sale_type == 2 } #内销
    msales.each do |msale|
      unless msale.nil?
        @month_sum2 += msale.day
        @inlay_sum2 += msale.inlay
        @pt_sum2 += msale.pt
        @gold_sum2 += msale.gold
        @kgold_sum2 += msale.kgold
        @other_sum2 += msale.other
        @old_gold_sum2 += msale.old_gold
        @old_pt_sum2 += msale.old_pt
        @gold_jade_sum2 += msale.gold_jade
        @color_stone_sum2 += msale.color_stone
      end
    end
    @new_material_month_sum2 = @inlay_sum2 + @pt_sum2 + @gold_sum2 + @kgold_sum2 + @other_sum2 + @gold_jade_sum2 + @color_stone_sum2
    @old_material_month_sum2 = @old_gold_sum2 + @old_pt_sum2
  end

  def export_write_data(sales_data, store, export_date)
    Spreadsheet.client_encoding = 'UTF-8'

    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet

    sheet1.name = "#{store.name}_#{export_date.to_s[0..-4]}"

#header
    sheet1.row(0).insert 0, "日期", "星期", "(#{store.name}) 店"
    sheet1.row(1).insert 2, *['镶 嵌', 'Pt', '黄 金', '金镶玉', '彩 宝', 'K金', '其它', '合计', '黄金旧料', 'Pt旧料', '旧料合计','当天合计', '本月累计']
    sheet1.row(2).insert 2, *%w{营业额 营业额 营业额 营业额 营业额 营业额 营业额 营业额 营业额}

#data
    month_sum = inlay_sum = pt_sum = gold_sum = kgold_sum = other_sum = old_gold_sum = old_pt_sum = gold_jade_sum = color_stone_sum = 0
    month_sum2 = inlay_sum2 = pt_sum2 = gold_sum2 = kgold_sum2 = other_sum2 = old_gold_sum2 = old_pt_sum2 = gold_jade_sum2 = color_stone_sum2 = 0
    (export_date.beginning_of_month.day.to_i..export_date.end_of_month.day).each do |mday|
      mdate = export_date.change(:day=>mday)
      week = ["日", "一", "二", "三", "四", "五", "六"][mdate.wday]
      row_data = sheet1.row(mday+2)
      row_data.insert 0, *[mday, week]
      msale = sales_data.find { |ms| ms.sale_time == mdate and ms.sale_type == 1 } #外销
      unless msale.nil?
        month_sum += msale.day
        inlay_sum += msale.inlay
        pt_sum += msale.pt
        gold_sum += msale.gold
        gold_jade_sum += msale.gold_jade
        color_stone_sum += msale.color_stone
        kgold_sum += msale.kgold
        other_sum += msale.other
        old_gold_sum += msale.old_gold
        old_pt_sum += msale.old_pt
        row_data.insert 2, msale.inlay, msale.pt, msale.gold, msale.gold_jade, msale.color_stone, msale.kgold, msale.other, (msale.inlay + msale.pt + msale.gold + msale.kgold + msale.other), msale.old_gold, msale.old_pt, (msale.old_gold + msale.old_pt), msale.day, month_sum
      end
      msale = sales_data.find { |ms| ms.sale_time == mdate and ms.sale_type == 2 } #内销
      unless msale.nil?
        month_sum2 += msale.day
        inlay_sum2 += msale.inlay
        pt_sum2 += msale.pt
        gold_sum2 += msale.gold
        gold_jade_sum2 += msale.gold_jade
        color_stone_sum2 += msale.color_stone
        kgold_sum2 += msale.kgold
        other_sum2 += msale.other
        old_gold_sum2 += msale.old_gold
        old_pt_sum2 += msale.old_pt
      end

    end

    #footer
    i = 1
    sheet1.row(3+export_date.end_of_month.day).insert(0, "商场合计")
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, inlay_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, pt_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, gold_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, gold_jade_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, color_stone_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, kgold_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, other_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, inlay_sum + pt_sum + gold_sum + kgold_sum + other_sum + gold_jade_sum + color_stone_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, old_gold_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, old_pt_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, old_gold_sum + old_pt_sum)
    sheet1.row(3+export_date.end_of_month.day).insert(i+=1, month_sum)

    i = 1
    sheet1.row(4+export_date.end_of_month.day).insert(0, "内销")
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, inlay_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, pt_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, gold_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, gold_jade_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, color_stone_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, kgold_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, other_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, inlay_sum2 + pt_sum2 + gold_sum2 + kgold_sum2 + other_sum2 + gold_jade_sum2 + color_stone_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, old_gold_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, old_pt_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, old_gold_sum2 + old_pt_sum2)
    sheet1.row(4+export_date.end_of_month.day).insert(i+=1, month_sum2)

    i = 1
    sheet1.row(5+export_date.end_of_month.day).insert(0, "当月累计")
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, inlay_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, pt_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, gold_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, gold_jade_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, color_stone_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, kgold_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, other_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, inlay_sum + pt_sum + gold_sum + kgold_sum + other_sum + gold_jade_sum +  color_stone_sum2)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, old_gold_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, old_pt_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, old_gold_sum + old_pt_sum)
    sheet1.row(5+export_date.end_of_month.day).insert(i+=1, month_sum)

#format
    default_format = Spreadsheet::Format.new :align => :center #居中

    sheet1.default_format=default_format

    #合并 商场合计 内销表格
    sheet1.row(3+export_date.end_of_month.day).set_format(0, Spreadsheet::Format.new(:align => :merge))
    sheet1.row(3+export_date.end_of_month.day).set_format(1, Spreadsheet::Format.new(:align => :merge))
    sheet1.row(4+export_date.end_of_month.day).set_format(0, Spreadsheet::Format.new(:align => :merge))
    sheet1.row(4+export_date.end_of_month.day).set_format(1, Spreadsheet::Format.new(:align => :merge))

    #居中销售数值
    2.upto(9).each do |mi|
      sheet1.row(3+export_date.end_of_month.day).set_format(mi, Spreadsheet::Format.new(:weight => :bold, :align => :center))
    end
    0.upto(9).each do |mi|
      sheet1.row(5+export_date.end_of_month.day).set_format(mi, Spreadsheet::Format.new(:weight => :bold, :align => :center))
    end

    #合并加粗 当月累计
    sheet1.row(5+export_date.end_of_month.day).set_format(0, Spreadsheet::Format.new(:align => :merge, :weight => :bold))
    sheet1.row(5+export_date.end_of_month.day).set_format(1, Spreadsheet::Format.new(:align => :merge, :weight => :bold))

    sheet1.column(0).width=5.25
    sheet1.column(1).width=5.25

    filename = "#{Rails.root}/tmp/#{export_date.to_s[0..-4]}_#{store.name}_#{rand(1000)}_export.xls"
    book.write filename
    filename
  end
end
