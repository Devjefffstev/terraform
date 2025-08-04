import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  iterations: 1000000,
  vus: 20,
  duration: '24h'
};

// The default exported function is gonna be picked up by k6 as the entry point for the test script. It will be executed repeatedly in "iterations" for the whole duration of the test.
export default function () {
  // Make a GET request to the target URL

  http.get('http://helloworld.aws.ociatepam.online/');
  http.get('http://opencost.nonprod.aws.ociatepam.online');
  http.get('http://opencost.aws.ociatepam.online');

  // Sleep for 1 second to simulate real-world usage
  sleep(1);
}