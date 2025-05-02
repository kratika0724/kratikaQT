import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_textstyles.dart';
import '../base main/vendor/wallet_screen.dart';
import '../vendor_pages/wallets/cash_wallet_screen.dart';
import '../vendor_pages/wallets/online_wallet_screen.dart';
import '../vendor_pages/wallets/settlement_wallet_screen.dart';


// Wallet Header Widget
class WalletCardHeader extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const WalletCardHeader({
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: isExpanded ? 10.0 : 16.0),
          child: Row(
            children: [
              if(!isExpanded)
                Icon(
                   Icons.add,
                  color: AppColors.primary,
                ),
              if(isExpanded)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Icon(
                    Icons.minimize,
                    color: AppColors.primary,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "User Wallets",
                    style: mediumTextStyle(fontSize: dimen16, color: AppColors.textBlack),
                  ),
                ),
              ),
              // Icon(
              //   isExpanded ? Icons.arrow_drop_up : Icons.add,
              //   color: AppColors.primary,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// Wallet Grid Widget
class WalletGrid extends StatelessWidget {
  final List<WalletData> wallets = const [
    WalletData(Icons.account_balance_wallet, "Cash Collection", "₹ 2045"),
    WalletData(Icons.wallet, "Main Wallet","₹ 100"),
    WalletData(Icons.attach_money, "Settlement Wallet", "₹ 30130"),
    WalletData(Icons.online_prediction, "System Collection", "₹ 47809"),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: wallets.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        final wallet = wallets[index];
        return WalletItem(
          data: wallet,
          onTap: () {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Tapped on ${wallet.label}')));
            //   if(wallet.label == "Cash Wallet") {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (_) => CashWalletScreen()));
            //   }
            //   if(wallet.label == "Main Wallet") {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (_) => WalletScreen()));
            //   }
            //   if(wallet.label == "Settlement Wallet") {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (_) => SettlementWalletScreen()));
            //   }
            //   if(wallet.label == "Online Wallet") {
            //     Navigator.push(
            //         context, MaterialPageRoute(builder: (_) => OnlineWalletScreen()));
            //   }
          },
        );
      },
    );
  }
}

class WalletData {
  final IconData icon;
  final String label;
  final String amount;
  const WalletData(this.icon, this.label, this.amount);
}

class WalletItem extends StatelessWidget {
  final WalletData data;
  final VoidCallback? onTap;

  const WalletItem({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.background, // soft tinted background
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon with rounded background
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(data.icon, color: AppColors.primary, size: 17),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      data.amount,
                      textAlign: TextAlign.center,
                      style: semiBoldTextStyle(fontSize: dimen15, color: AppColors.secondary),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),

              // Optional visual separator
              Container(
                height: 1,
                color: Colors.grey.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),


              Text(
                data.label,
                textAlign: TextAlign.center,
                style: mediumTextStyle(fontSize: dimen14, color: AppColors.textBlack),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      )

    );
  }
}