// k6 run tests/load/smoke.js  (after: kubectl -n demo port-forward svc/demo 8081:80)
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 20,
  duration: '2m',
  thresholds: {
    http_req_failed: ['rate<0.005'],
    http_req_duration: ['p(99)<300'],
  },
};

export default function () {
  const res = http.get(`${__ENV.BASE_URL || 'http://localhost:8081'}/api/hello`);
  check(res, { 'status 200': (r) => r.status === 200 });
  sleep(0.1);
}
