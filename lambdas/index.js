exports.handler = async (event) => {
    console.log(event);
    const response = {
        statusCode: 200,
        body: JSON.stringify(event),
    };
    return response;
};
