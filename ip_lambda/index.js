exports.handler = async (event) => {
  try {
    if (!event.Records || event.Records.length === 0) {
      console.log("No messages received.");
      return {
        statusCode: 200,
        body: JSON.stringify({ message: "No messages in queue" }),
      };
    }

    event.Records.map((record) => {
      const body = JSON.parse(record.body);
      console.log("IP:", body.ip);
      console.log("Time:", body.timestamp);
    });
  } catch (error) {
    console.error("Error processing SQS message:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Failed to process SQS message" }),
    };
  }
};
