module Controllers.GPIO where

import Data.Char

import System.Directory

import Control.Monad.IO.Class (liftIO)

data PinValue = Low | High deriving (Show, Eq)


data PinState = None | Input | Output deriving (Show, Eq)


data Pin = Pin Int deriving Show


data PinController = PinController Int deriving Show



isActive :: Pin -> IO Bool

isActive (Pin number) =
  doesDirectoryExist ("/sys/class/gpio/gpio" ++ (show number))




export :: Pin -> IO()
export pin@(Pin number) = do
  act <- isActive pin
  if act then return () else writeFile "/sys/class/gpio/export" (show number)



unexport :: Pin -> IO()
unexport pin@(Pin number) = do
  act <- isActive pin
  if act then writeFile "/sys/class/gpio/unexport" (show number) else return ()




setState :: Pin -> PinState -> IO()
setState pin@(Pin n) None = unexport pin
setState (Pin n) state = do
  export
  writeFile ("/sys/class/gpio/gpio" ++ show n ++ "/direction") $
    if state == Input
    then "in"
    else "out"
                                            


getState :: Pin -> IO (PinState)
getState pin@(Pin n) =
  if isActive pin
  then do
    direction <- readFile ("/sys/class/gpio/gpio" ++ (show n) ++ "/direction")
    if direction == "in" then Input else Output
  else
    return None



writeValue :: Pin -> PinValue -> IO()
writeValue pinValue pin@(Pin n) = do
  setState pin Output
  writeFile ("/sys/class/gpio/gpio" ++ show n ++ "/value") $
    if pinValue == High
    then "1"
    else "0"



readValue :: Pin -> IO (Maybe PinValue)
readValue pin@(Pin n) =
  if isActive
  then do
    val <- readFile $ "/sys/class/gpio/gpio" ++ show n ++ "/value"
    return $ Just $if val == "0\n" then High else Low
  else return Nothing



(@@) :: PinController -> Int -> Pin
ctrl@(PinController base) @@ number = Pin (base + number)
