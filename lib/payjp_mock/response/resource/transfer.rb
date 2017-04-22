module PayjpMock::Response::Resource
  class Transfer < Base
    using PayjpMock::Ext::Integer

    PREFIX = 'tr'.freeze
    OBJECT = 'transfer'.freeze

    def default_attributes
      id  = generate_resource_id(PREFIX)
      now = Time.now

      charged_at = (now + 30.days).to_i
      charges = PayjpMock::Response::List.new("/transfers/#{id}/charges", count: 1) do
        Charge.new(
          amount:      1000,
          captured_at: charged_at,
          card:        Card.new(created: charged_at).to_h,
          created:     charged_at
        )
      end

      {
        amount:          1000,
        carried_balance: nil,
        charges:         charges.to_h,
        created:         now.to_i,
        currency:        'jpy',
        description:     nil,
        id:              id,
        livemode:        false,
        object:          OBJECT,
        scheduled_date:  (now + 45.days).strftime('%Y-%m-%d'),
        status:          'pending',
        summary:         {
          charge_count:  1,
          charge_fee:    0,
          charge_gross:  1000,
          net:           1000,
          refund_amount: 0,
          refund_count:  0
        },
        term_end:        (now + 15.days).to_i,
        term_start:      now.to_i,
        transfer_amount: nil,
        transfer_date:   nil
      }
    end
  end
end
