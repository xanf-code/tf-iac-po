exports.handler = async (event) => {
  try {
    console.log("Received event from SQS:", JSON.stringify(event, null, 2));

    if (!event.Records || event.Records.length === 0) {
      console.log("No messages received.");
      return {
        statusCode: 200,
        body: JSON.stringify({ message: "No messages in queue" }),
      };
    }

    const messages = event.Records.map((record) => {
      console.log("Processing message:", record.body);
      return record.body;
    });

    return {
      statusCode: 200,
      body: JSON.stringify({ message: "Messages processed", data: messages }),
    };
  } catch (error) {
    console.error("Error processing SQS message:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Failed to process SQS message" }),
    };
  }
};
