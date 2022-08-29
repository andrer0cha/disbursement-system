# Disbursement Calculator

## Overview

The idea of this project is to calculate the disbursement for each merchant present in the Database and expose it in an endpoint that can be filtered to see data only for a specific merchant.

## Architecture
Since we are using Rails here, the project follows the MVC principle completely.

### Database

Since that's a simple project, with low complexity, the chosen database to persist the data is the Rails built-in SQLite3.

### Models/Tables

The models and tables that will define the database schema and handle business cases is exactly what was suggested on the challenge's original description:

```
MERCHANTS
ID | NAME                      | EMAIL                             | CIF
1  | Treutel, Schumm and Fadel | info@treutel-schumm-and-fadel.com | B611111111
2  | Windler and Sons          | info@windler-and-sons.com         | B611111112
3  | Mraz and Sons             | info@mraz-and-sons.com            | B611111113
4  | Cummerata LLC             | info@cummerata-llc.com            | B611111114

SHOPPERS
ID | NAME                 | EMAIL                              | NIF
1  | Olive Thompson       | olive.thompson@not_gmail.com       | 411111111Z
2  | Virgen Anderson      | virgen.anderson@not_gmail.com      | 411111112Z
3  | Reagan Auer          | reagan.auer@not_gmail.com          | 411111113Z
4  | Shanelle Satterfield | shanelle.satterfield@not_gmail.com | 411111114Z

ORDERS
ID | MERCHANT ID | SHOPPER ID | AMOUNT | CREATED AT           | COMPLETED AT
1  | 25          | 3351       | 61.74  | 01/01/2017 00:00:00  | 01/07/2017 14:24:01
2  | 13          | 2090       | 293.08 | 01/01/2017 12:00:00  | nil
3  | 18          | 2980       | 373.33 | 01/01/2017 16:00:00  | nil
4  | 10          | 3545       | 60.48  | 01/01/2017 18:00:00  | 01/08/2017 15:51:26
5  | 8           | 1683       | 213.97 | 01/01/2017 19:12:00  | 01/08/2017 14:12:43

DISBURSEMENTS
ID | MERCHANT ID | TOTAL  | RELATED WEEK | CREATED AT           | APPLIED FEE
1  | 25          | 1.74   | 2            | 12/01/2017 00:00:00  | 0.01
2  | 13          | 3.08   | 2            | 12/01/2017 12:00:00  | 0.01
3  | 18          | 3.33   | 2            | 12/01/2017 16:00:00  | 0.095
4  | 10          | 1.48   | 1            | 01/01/2017 18:00:00  | 0.085
5  | 8           | 0.97   | 1            | 01/01/2017 19:12:00  | 0.085
```
### Controllers
For now, we just want to expose one endpoint, the one that returns all the disbursements and allow us to filter by a specific merchant if needed.
So, we just need a simple controller with an `#index` route - it is also be the application root.

### Background Jobs
As the calculations can take some time to be completed, we want to isolate it from the web application to avoid pausing requests to complete them. To do that, we handle the calculations on background jobs using the gem [delayed job](https://github.com/collectiveidea/delayed_job).

## Instructions
To set the application and have it running locally is super straightfoward, one just need to have the Ruby language (v. 3.1.2) installed and some package manager like `Bundler`.

With all the project dependencies installed and inside the application folder, just need to follow the next steps:
1. `rails db:create`
2. `rails db:migrate`
3. `rails db:seed`
4. `rails server`
5. Access the server URL (usually http://localhost:3000) and have fun.

To have the disbursements, we need to run the `rake 'calculators:weekly_disbursement'` task, since it's scheduled to run only on Mondays, we can run it manually just to have data on our DB:

Running the command above will put it in the queue to be run later but will not actually run it. To do so, we need to also perform the following command:

`rake jobs:workoff`

## Possible Future Improvements
- Add retries to `rake 'calculators:weekly_disbursement'` task in case of any errors
- Make the application JSONAPI complient
- Add serializers to better present data
- Add fixtures to avoid creation of many entities during tests
- Add authorization/authentication
- Add `eager_load` gem to track and avoid n+1 queries


## Project Dependencies
- **Ruby:**       3.1.2
- **Rails:**   ~> 7.0.3
- **SQLite3:** ~> 1.4
- **Bundler:** 2.3.17
