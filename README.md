# Goal of IDClaim
A typical database table contains a `PRIMARY KEY` column, often with an `ID` column and `IDENTITY` turned on for it. This way there's no need for the developer to worry about the value of this column and it's guaranteed to be unique, even during highly concurrent operations. The downside of this approach &ndash; especially when applications are waiting for the results &ndash; is the latency. This micro library aims to solve this problem by providing a standard solution requiring minimal implementation work.

# What is IDClaim
`IDClaim` consists of a *database* and a *library* part which work hand in hand. The management of the ID's for a particular table is still done by the *database* to guarantee there won't be any conflicting claimed ranges. The *library* utilizes this feature to optimally claim ranges and manage them within the application, no matter how highly concurrent the application may be. This holds even true if the application runs in multiple instances, because each will have its own claimed range.

# How does IDClaim work
The core management of the available ranges &ndash; including historics &ndash; is in the *database*. A `table` contains all last provided claims and a `stored procedure` manages new claims, including maintenance of the current state and historics.

The library contains an `ID Claim Manager`, which is completely thread safe and manages claims for one `table` of your database. It makes sure that it only provides ID's which fall inside the claimed range and makes sure it starts claiming a new range before you run out of the current one, to reduce the waiting time.

# Benefits of IDClaim
Because the application knows on forehand which ID a record will have, it's able to construct structures without involving the *database*, which will slow down the operation if the application has to wait for it. Especially during highly concurrent operations or quickly following operations whic required the result of the last operation, the gains can be humongous.

# Downsides of IDClaim
Because the ID's aren't managed by an `IDENTITY`, the target database schema shouldn't use it either. Additionally when working with constraints &ndash; i.e. `FOREIGN KEY` &ndash; the application must make sure the records are inserted in the correct order. Typically this shouldn't be an issue, because records should be inserted in **ascending** order, which is a **smell** if your application doesn't behave this way (trying to insert the dependant record before the referred one).

# How to use IDClaim
There are two things to consider after "installation": configuration of the *database* and creating instances of `ID Claim Manager`.

## Database configuration
The table `IDClaim` contains all available and lastly claimed ranges. Make sure that the table is in there and otherwise execute the `stored procedure` `CreateClaim`
```sql
EXEC [dbo].[RequestClaim] 'Log', 'dbo', 'Log', '1', '1000';
```

It will make sure that from that moment on for the table `[Log].[dbo].[Log]` claims can be made.

### Creating `ID Claim Manager` instances
All there is to it, is creating a new instance and calling its `GetNextIDClaim` method. The manager will handle everything, including retrieving new claim ranges and making sure no duplicate or incorrect ID is returned.
```csharp
IDClaimManager manager = new IDClaimManager("Log", "dbo", "Log", 1000, 900, "FancyApplication");
```
In this example, `1000` refers to the size of the ranges to claim; `900` after how many claims the manager should start claiming the next range to improve continuity and `FancyApplication` as the requestor, to support tracing back which application has been responsible for the claimed ranges.