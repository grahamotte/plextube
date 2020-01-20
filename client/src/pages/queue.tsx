import Layout from "../components/layout";
import React from "react";
import Spinner from "../components/spinner";
import { Table } from "bloomer";
import { format } from "timeago.js";
import { observer } from "mobx-react";
import store from "../stores";

class Klass extends React.Component {
  render() {
    if (store.jobs.all.length === 0) {
      return (
        <Layout>
          <i>No jobs in the queue.</i>
        </Layout>
      );
    }

    return (
      <Layout>
        <Table style={{ width: "100%" }}>
          <thead>
            <tr>
              <th></th>
              <th>Job</th>
              <th>Args</th>
              <th>Attempts</th>
              <th>Errors</th>
              <th>Age</th>
            </tr>
          </thead>

          <tbody>
            {store.jobs.all.map((j: any, ji) => {
              return (
                <tr key={ji}>
                  <td style={{ verticalAlign: "middle" }}>
                    {j.running && <Spinner />}
                  </td>
                  <td style={{ verticalAlign: "middle" }}>{j.class}</td>
                  <td style={{ verticalAlign: "middle" }}>{j.arguments}</td>
                  <td style={{ verticalAlign: "middle" }}>{j.attempts}</td>
                  <td
                    style={{
                      verticalAlign: "middle"
                    }}
                  >
                    {j.error && j.error.length > 0 && <code>{j.error}</code>}
                  </td>
                  <td style={{ verticalAlign: "middle" }}>
                    {format(j.created_at)}
                  </td>
                </tr>
              );
            })}
          </tbody>
        </Table>
      </Layout>
    );
  }
}

export default observer(Klass);
