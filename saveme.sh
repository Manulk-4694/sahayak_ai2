echo '--------------------->starting cleanup process, sit back and relax 🤌🏻💆🏻‍♂️🧘🏻‍♂️'
flutter clean
echo '---------------------> 1️⃣ flutter clean completed 👌🏻 '
rm -rf android/app/build
rm -rf build
echo '---------------------> 2️⃣ deleted build folders 👌🏻 '
rm pubspec.lock
flutter pub get
flutter pub cache repair
echo '---------------------> 3️⃣ pub get completed 👌🏻'
read -p "Do yoyeu wish to cleanup ios file as well bro? (yes/no): " choice
if [[ $choice == "yes" ]]; then
cd ios
rm podfile.lock
pod install
pod repo update
cd -
echo '---------------------> 🎉🎉🎉 cleanup completed succesfully 🎉🎉🎉';
elif [[ $choice == "no" ]]; then
  echo "Cleaning Completed."
else
  echo "Invalid choice. Please enter 'yes' or 'no'."
fi


