using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerLook : MonoBehaviour
{

    [SerializeField] private float sensX;
    [SerializeField] private float sensY;


    Camera cam;

    float mouseX;
    float mouseY;

    float multiplier = 0.01f;

    float xRotation = 0;
    float yRotation = 0;



    // Start is called before the first frame update
    void Start()
    {
        cam = GetComponentInChildren<Camera>();
        if (cam == null)
        {
            cam = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
        }

        // Lock cursor
        Cursor.lockState = CursorLockMode.Locked;
        Cursor.visible = false; 
    }

    // Update is called once per frame
    void Update()
    {
        HandleInput();
        
       
        cam.transform.localRotation = Quaternion.Euler(xRotation, 0, 0);

        // only want player to rotate on y axis
        transform.rotation = Quaternion.Euler(0, yRotation, 0);
    }

    void HandleInput()
    {
        // get the current mouse position
        mouseX = Input.GetAxisRaw("Mouse X");
        mouseY = Input.GetAxisRaw("Mouse Y");

        // when we rotate horizontally, we move on y axis
        yRotation += mouseX * sensX * multiplier;
        // moving on x makes camera look up and down
        xRotation -= mouseY * sensY * multiplier;

        // clamp so you cant look to far up or down
        xRotation = Mathf.Clamp(xRotation, -90f, 90f); 
    }
}
