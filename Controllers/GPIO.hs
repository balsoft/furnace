module Controllers.GPIO where

import Data.Char

import System.Directory

data PinValue = Low | High deriving (Show, Eq)


data PinState = None | Input | Output PinValue deriving (Show, Eq)


data Pin = Pin Int PinState deriving Show


data PinController = PinController Int deriving Show



pinActive :: PinController -> Pin -> IO Bool

pinActive _ (Pin n None) = return False

pinActive (PinController base) (Pin number _) = doesDirectoryExist ("/sys/class/gpio/gpio" ++ (show (base + number)))



setDirection :: Int -> String -> IO()

setDirection n = writeFile ("/sys/class/gpio/gpio" ++ show n ++ "/direction")



doExport :: PinController -> Pin -> IO()

doExport ctrl@(PinController base) pin@(Pin number _)
  | pinActive ctrl pin = return ()
  | otherwise = writeFile "/sys/class/gpio/export" $ show $ base + number
                                                     


(@>) :: Pin -> PinController -> IO()

pin@(Pin number None) @> ctrl@(PinController base)
  | pinActive ctrl pin = do
      writeFile "/sys/class/gpio/unexport" $ show $ base + number
  | otherwise = return ()

pin@(Pin number Input) @> ctrl@(PinController base) = do
  ctrl' <- doExport ctrl pin
  setDirection (number + base) "in"
  return ctrl'

pin@(Pin number (Output val)) @> ctrl@(PinController base) = do
  ctrl' <- doExport ctrl pin
  setDirection (number + base) $ map toLower $ show val
  return ctrl'



(@@) :: PinController -> Int -> IO (Maybe PinValue)
ctrl@(PinController base) @@ number
  | pinActive ctrl (Pin number Input) = do
      val <- readFile ("/sys/class/gpio/gpio" ++ show (base + number) ++ "/value")
      return $ Just (if val == "0\n" then Low else High)
  | otherwise = return Nothing


