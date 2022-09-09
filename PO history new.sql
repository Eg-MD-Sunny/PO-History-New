SELECT 
	   [PurchaseOrder].[Id] PurchaseOrderId
	  ,[PurchaseOrder].[PurchaseOrderStatusId]
      ,CAST(dbo.tobdt([PurchaseOrder].[CreatedOn]) as date) CreatedOn
	  ,CAST(dbo.tobdt([PurchaseOrder].[CompletedOn]) as  datetime) CompletedOn
	  ,PO_EMP.BadgeId PO_PlacedBy
	  ,PO_DES.DesignationName
	  ,PO_EMP.FullName PO_PlacedByEmployee
      ,[PurchaseOrder].[VendorId]
	  ,Vendor.Name VendorName
      ,[PurchaseOrder].[SourcingWarehouseId]
	  , Warehouse.Name SourcingWarehouseName
      ,PurchaseOrderProductVariant.ProductVariantId
	  ,ProductVariant.Name ProductVariantName
      ,PurchaseOrderProductVariant.[DeficitQuantity]
      ,PurchaseOrderProductVariant.[RequestedQuantity]
	  ,COUNT(*) ReceivedQuantity
      ,[Thing].[CostPrice]
      ,[Thing].[Mrp]
	  , (([Thing].[Mrp] - [Thing].[CostPrice]) / [Thing].[Mrp]) * 100 GP
	  , Employee.BadgeId PriceSetByCDBD
	  , Designation.DesignationName
	  ,Employee.FullName PriceSetEmployee

 FROM [egg1].[dbo].[PurchaseOrder]
	Left join PurchaseOrderProductVariant on PurchaseOrder.Id=PurchaseOrderProductVariant.PurchaseOrderId
	Left join [Thing] on PurchaseOrder.Id = [Thing].[PurchaseOrderId] and [Thing].ProductVariantId = PurchaseOrderProductVariant.[ProductVariantId]
	Left Join ProductVariant on ProductVariant.Id = PurchaseOrderProductVariant.[ProductVariantId]
	Left Join Employee on Employee.Id = [Thing].[PriceSetByEmployeeId]
	Left Join Designation on Employee.DesignationId = Designation.Id
	Left Join Warehouse On [PurchaseOrder].[SourcingWarehouseId] = Warehouse.Id
	Left Join Vendor On Vendor.Id = [PurchaseOrder].[VendorId]
	Left Join Employee PO_EMP On  PurchaseOrder.PlacedByCustomerId=PO_EMP.Id
	Left Join Designation PO_DES On PO_EMP.DesignationId = PO_DES.Id
	
		  
Where 
	[PurchaseOrder].[PurchaseOrderStatusId] in (2 , 4)
	and Thing.ProductVariantId in (27704)
	and [Thing].[CostPrice] is not null

Group by
	   [PurchaseOrder].[Id] 
	  ,[PurchaseOrder].[PurchaseOrderStatusId]
      ,CAST(dbo.tobdt([PurchaseOrder].[CreatedOn]) as date) 
      ,[PurchaseOrder].[VendorId]
	  , Vendor.Name 
      ,[PurchaseOrder].[CompletedOn]
      ,[PurchaseOrder].[SourcingWarehouseId]
	  ,Warehouse.Name 
      ,PurchaseOrderProductVariant.ProductVariantId
	  ,ProductVariant.Name 
      ,PurchaseOrderProductVariant.[DeficitQuantity]
      ,PurchaseOrderProductVariant.[RequestedQuantity]
      ,[Thing].[CostPrice]
      ,[Thing].[Mrp]
	  , Employee.BadgeId 
	  , Designation.DesignationName
	  ,Employee.FullName 
	  ,PO_EMP.BadgeId 
	  ,PO_DES.DesignationName
	  ,PO_EMP.FullName 

Order by CompletedOn desc,
         CreatedOn desc
