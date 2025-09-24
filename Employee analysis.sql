select dense_rank() over(order by od.UnitPrice * od.quantity desc) as rank,concat(e.firstname," ", e.lastname) as emp_name, od.UnitPrice * od.quantity as revenue from nw_employees e
join nw_orders o
on e.EmployeeID = o.EmployeeID
join nw_order_details od
on o.OrderID = od.OrderID
group by concat(e.firstname," ", e.lastname)


select monthname(o.orderdate) as month,sum(od.Quantity),sum(sum(od.Quantity)) over(order by monthname(o.orderdate)) as cum_quantity
 from nw_orders o
join nw_order_details od
on o.OrderID = od.OrderID
join nw_products p
on od.ProductID = p.ProductID
group by monthname(o.orderdate)
order by monthname(o.orderdate);

select s.CompanyName,sum(nd.UnitPrice*nd.Quantity), sum(nd.UnitPrice*nd.Quantity)*100/sum(sum(nd.UnitPrice*nd.Quantity)) over() as revenue_perc from nw_suppliers s
join nw_products p
on s.SupplierID = p.SupplierID
join nw_order_details nd
on p.ProductID = nd.ProductID
group by s.CompanyName
order by revenue_perc;

select s.CompanyName,count(distinct(nd.OrderID)), count(distinct(nd.OrderID))*100/sum(count(distinct(nd.OrderID))) over() as order_perc from nw_suppliers s
join nw_products p
on s.SupplierID = p.SupplierID
join nw_order_details nd
on p.ProductID = nd.ProductID
group by s.CompanyName
order by order_perc;

select p.ProductName,o.OrderDate,year(o.orderdate), sum(od.Quantity),lag(sum(od.Quantity)) over(partition by p.ProductName order by year(o.orderdate)), 
round((sum(od.Quantity) - lag(sum(od.Quantity)) over(partition by p.ProductName order by year(o.orderdate))) * 100 / nullif(lag(sum(od.Quantity)) over(partition by p.ProductName order by year(o.orderdate)),0),2)
from nw_products p
join nw_order_details od
on p.ProductID = od.ProductID
join nw_orders o
on od.OrderID = o.OrderID
group by p.productname,year(o.orderdate);
