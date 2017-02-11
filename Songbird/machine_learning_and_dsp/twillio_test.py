from twilio.rest import TwilioRestClient


def send_notification(message):
    # Sends an sms message; convenient if your running long tests; Note: phone numbers must be validated in the free version of twillio
    # https://www.twilio.com/
    ACCOUNT_SID = "AC080cc7cb5f19db88057c70a4f04fa10e"
    AUTH_TOKEN = "b0f51bbc876ab3b255ec21678c6f0606"

    client = TwilioRestClient(ACCOUNT_SID, AUTH_TOKEN)

    client.messages.create(
        to="+19899287381",
        from_="+19893416033",
        body=message,
    )


if __name__ == '__main__':
    send_notification('test_notification')
