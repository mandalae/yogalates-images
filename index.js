const aws = require('aws-sdk');

const s3 = new aws.S3({apiVersion: '2006-03-01', signatureVersion: 'v4', region: 'eu-west-1'});

const bucketName = "cdn.yogalates.dk";

exports.handler = async (event) => {
    return new Promise(async (resolve, reject) => {
        let response = {
            statusCode: 200,
            headers: {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            body: ''
        };

        const done = (err, res) => {
            if (!err){
                response.body = JSON.stringify(res);
                resolve(response);
            } else {
                response.body = JSON.stringify(err);
                response.statusCode = 400;
                reject(response);
            }
        }


        switch (event.httpMethod) {
            case 'GET':
                const documentToUpload = event.queryStringParameters.document;
                const mimeType = event.queryStringParameters.mimeType;

                console.log('Document to upload', documentToUpload);
                let params = {
                  Bucket: bucketName,
                  Key: documentToUpload,
                  Expires: 10
                };

                if (mimeType){
                    params.ContentType = mimeType;
                }
                console.log(params);

                const url = s3.getSignedUrl('putObject', params);

                done(null, url);
                break;
            default:
                done(new Error(`Unsupported method "${event.httpMethod}"`));
        }
    });
}
