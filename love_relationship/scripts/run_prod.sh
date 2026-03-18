#!/bin/bash
# Executa o app no ambiente PRODUÇÃO
echo "Running \"A2\" - PROD"
flutter run --flavor prod --target lib/main_prd.dart --release
