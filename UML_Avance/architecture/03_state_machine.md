# Machine à états

```mermaid
stateDiagram-v2
    [*] --> DRAFT : cart_created
    DRAFT --> PENDING_PAYMENT : checkout_button_clicked
    PENDING_PAYMENT --> PAID : payment_success
    PENDING_PAYMENT --> FAILED : payment_refused
    FAILED --> PENDING_PAYMENT : retry_payment
    PAID --> SHIPPED : order_dispatched
    SHIPPED --> [*] : order_delivered
```
