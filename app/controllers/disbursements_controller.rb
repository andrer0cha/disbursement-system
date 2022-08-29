# frozen_string_literal: true

class DisbursementsController < ApplicationController
  def index
    disbursements = Disbursement.where(
      created_at: Time.zone.today.beginning_of_week..DateTime::Infinity.new
    )
    if permitted_params[:email].present?
      disbursements = disbursements.joins(:merchant).where(
        merchant: {
          email: permitted_params[:email]
        }
      )
    end

    render json: disbursements
  end

  private

  def permitted_params
    params.permit(:email)
  end
end
