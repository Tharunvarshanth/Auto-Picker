import 'package:auto_picker/models/mechanic.dart';

const String applicationName = "auto_picker";

class Users {
  static const Admin = 'admin';
  static const NormalUser = 'user';
  static const Mechanic = 'mechanic';
  static const Seller = 'seller';
}

class UsersSignUp {
  static const NormalUser = 'user';
  static const Mechanic = 'mechanic';
  static const Seller = 'seller';
}

const MechanicSpecialistSkills = [
  "Three wheel",
  "Motorcycle",
  "Electirican",
  "Air Conditioning",
  "Auto Exhaust",
  "Engine",
  "Gear Box",
  "Radiator",
  "All Type Vehicles",
  "Brake and transmission",
  "Tire mechanics",
  "General automotive",
  "Auto body",
  "Service Station",
  "Auto glass"
];

class FirebaseCollections {
  static const Chats = 'chats';
  static const Feedbacks = 'feedbacks';
  static const FeedbackList = 'feedbackList';
  static const FuelManager = 'fuelManager';
  static const Mechanics = 'mechanics';
  static const MonthlyPaymentRecords = 'monthlyPaymentRecords';
  static const Notifications = 'notifications';
  static const NotificationsList = 'notificationsList';
  static const Products = 'products';
  static const ProductsList = 'productsList';
  static const Advertisement = 'sparePartsAdvertisements';
  static const AdvertisementList = 'sparePartsAdvertisementsList';
  static const Sellers = 'sparePartsSellers';
  static const Users = 'users';
  static const AdminControls = 'adminControls';
  static const Orders = 'orders';
  static const OrdersList = 'ordersList';
  static const VehicleServiceMaintenance = 'vehicleServiceMaintenance';
  static const VehicleServiceList = 'vehicleServiceList';
  static const FuelAlertList = 'fuelAlertList';
}

const SPAREPARTSCONDITIONLIST = ["Recondition", "Used", "Brand New"];

const TESTNUMBER = "+940772732976";
const PriceNegotiable = "Negotiable";

const ONESIGNALAPPID = "9118dd3d-282d-42e6-b3a2-78b5bee6c5a0";
const ORDERTITLTE = "Product Order Received";
const ORDERBODY = "You have got a order";
const NOTIFICATIONTYPES = ["Order"];
const NOTIFICATION_TYPE_ORDER = "Order";
const ORDER_CONFIRM_TITLE = 'Order Confirmed';
const ORDER_CONFIRM_BODY = 'Your order confirmed by product owner';

const ORDER_COMPLETED_TITLE = "Your order completed";
const ORDER_COMPLETED_BODY = "Your order marked as completed";

const VEHICLE_SERVICE_REMAINDER = "Vehicle Service Remainder";

const ORDER_CANCELLED_TITLE = 'Order Cancelled';
const ORDER_CANCELLED_BODY = 'Your order was cancelled';
