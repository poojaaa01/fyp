import 'package:flutter/material.dart';
import 'package:fyp/providers/order_provider.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/empty_apt.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const TitlesTextWidget(label: 'Appointments to be confirmed')),
      body: FutureBuilder(
        future: ordersProvider.fetchOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: SelectableText(snapshot.error.toString()));
          } else if (!snapshot.hasData || ordersProvider.getOrders.isEmpty) {
            return EmptyAptWidget(
              imagePath: AssetsManager.noApt,
              title: "No appointments has been made yet",
              subtitle: "",
              buttonText: "Wanna set one?",
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: OrdersWidgetFree(
                  ordersModelAdvanced: ordersProvider.getOrders[index],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                // thickness: 8,
                // color: Colors.red,
              );
            },
          );
        },
      ),
    );
  }
}
